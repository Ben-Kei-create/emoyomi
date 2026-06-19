import SwiftUI

enum ReadingMode: String, CaseIterable {
    case original = "原文"
    case easy = "やさしい日本語"
    case emo = "エモ訳"

    var shortLabel: String {
        switch self {
        case .original: return "原文"
        case .easy: return "やさしい"
        case .emo: return "エモ訳"
        }
    }
}

enum ReadingFontSize: String, CaseIterable {
    case small = "小"
    case medium = "中"
    case large = "大"

    var scale: CGFloat {
        switch self {
        case .small: return 0.85
        case .medium: return 1.0
        case .large: return 1.2
        }
    }
}

enum ReadingBackground: String, CaseIterable {
    case paper = "紙"
    case cream = "生成り"
    case white = "白"
}

@Observable
final class ReadingViewModel {
    let work: Work
    var currentIndex: Int = 0
    var selectedGlossary: GlossaryEntry?
    var isCompleted: Bool = false
    var readingMode: ReadingMode = .original
    var quoteSaved: Bool = false
    var showSaveToast: Bool = false
    var showMenu: Bool = false
    var fontSize: ReadingFontSize = .medium
    var backgroundStyle: ReadingBackground = .paper

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

    var progressPercent: String {
        "\(Int(progress * 100))%"
    }

    var progressText: String {
        "\(currentIndex + 1)/\(work.segments.count)"
    }

    var remainingSegments: Int {
        work.segments.count - currentIndex - 1
    }

    var estimatedMinutes: Int {
        max(1, remainingSegments)
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
        if let savedSize = UserDefaults.standard.string(forKey: "emoyomi_fontSize"),
           let size = ReadingFontSize(rawValue: savedSize) {
            self.fontSize = size
        }
        if let savedBg = UserDefaults.standard.string(forKey: "emoyomi_background"),
           let bg = ReadingBackground(rawValue: savedBg) {
            self.backgroundStyle = bg
        }
    }

    func cycleReadingMode() {
        let modes = ReadingMode.allCases
        guard let idx = modes.firstIndex(of: readingMode) else { return }
        readingMode = modes[(idx + 1) % modes.count]
    }

    func setFontSize(_ size: ReadingFontSize) {
        fontSize = size
        UserDefaults.standard.set(size.rawValue, forKey: "emoyomi_fontSize")
    }

    func setBackground(_ bg: ReadingBackground) {
        backgroundStyle = bg
        UserDefaults.standard.set(bg.rawValue, forKey: "emoyomi_background")
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
            selectedGlossary = nil
            quoteSaved = false
            showSaveToast = false
            store.saveProgress(ReadingProgress(
                workId: work.id,
                currentIndex: currentIndex,
                completed: false
            ))
        }
    }

    func reset() {
        currentIndex = 0
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
