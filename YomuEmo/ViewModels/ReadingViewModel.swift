import SwiftUI

enum ReadingMode: String, CaseIterable {
    case original = "原文"
    case easy = "やさしい日本語"
    case emo = "エモ訳"
}

@Observable
final class ReadingViewModel {
    let work: Work
    var currentIndex: Int = 0
    var showVibes: Bool = false
    var showEmotions: Bool = false
    var selectedGlossary: GlossaryEntry?
    var isCompleted: Bool = false
    var readingMode: ReadingMode = .original
    var showPoll: Bool = false
    var quoteSaved: Bool = false
    var showSaveToast: Bool = false

    private let store = StoreManager.shared

    var currentSegment: TextSegment {
        work.segments[currentIndex]
    }

    var displayText: String {
        switch readingMode {
        case .original: return currentSegment.originalText
        case .easy: return currentSegment.easyText
        case .emo: return currentSegment.emoText
        }
    }

    var progress: Double {
        Double(currentIndex + 1) / Double(work.segments.count)
    }

    var progressText: String {
        "\(currentIndex + 1)/\(work.segments.count)"
    }

    var currentPoll: Poll? {
        guard let pollIndex = currentSegment.pollIndex,
              pollIndex < work.polls.count else { return nil }
        return work.polls[pollIndex]
    }

    var aggregateEmotionScores: [EmotionTag: Int] {
        var totals: [EmotionTag: Int] = [:]
        var counts: [EmotionTag: Int] = [:]
        let limit = min(currentIndex + 1, work.segments.count)
        for i in 0..<limit {
            for (tag, score) in work.segments[i].emotionScores {
                totals[tag, default: 0] += score
                counts[tag, default: 0] += 1
            }
        }
        var result: [EmotionTag: Int] = [:]
        for (tag, total) in totals {
            result[tag] = total / (counts[tag] ?? 1)
        }
        return result
    }

    init(work: Work) {
        self.work = work
        let saved = store.getProgress(for: work.id)
        if saved.currentIndex < work.segments.count && !saved.completed {
            self.currentIndex = saved.currentIndex
        }
    }

    func cycleReadingMode() {
        let modes = ReadingMode.allCases
        guard let idx = modes.firstIndex(of: readingMode) else { return }
        readingMode = modes[(idx + 1) % modes.count]
    }

    func next() {
        store.recordDailyReading()

        if currentIndex >= work.segments.count - 1 {
            store.saveProgress(ReadingProgress(
                workId: work.id,
                currentIndex: work.segments.count,
                completed: true
            ))
            store.checkAchievements()
            isCompleted = true
        } else {
            currentIndex += 1
            showVibes = false
            showEmotions = false
            showPoll = false
            selectedGlossary = nil
            quoteSaved = false
            showSaveToast = false
            store.saveProgress(ReadingProgress(
                workId: work.id,
                currentIndex: currentIndex,
                completed: false
            ))

            if currentSegment.pollIndex != nil {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    withAnimation { self.showPoll = true }
                }
            }
        }
    }

    func reset() {
        currentIndex = 0
        showVibes = false
        showEmotions = false
        showPoll = false
        selectedGlossary = nil
        isCompleted = false
        quoteSaved = false
        showSaveToast = false
        store.saveProgress(ReadingProgress(
            workId: work.id,
            currentIndex: 0,
            completed: false
        ))
    }

    func saveCurrentQuote() {
        let quote = SavedQuote(
            text: currentSegment.originalText,
            workId: work.id,
            workTitle: work.title,
            authorId: work.authorId,
            authorName: work.authorName
        )
        store.saveQuote(quote)
        store.checkAchievements()
        quoteSaved = true
        showSaveToast = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            withAnimation(.easeOut(duration: 0.3)) { self.showSaveToast = false }
        }
    }
}
