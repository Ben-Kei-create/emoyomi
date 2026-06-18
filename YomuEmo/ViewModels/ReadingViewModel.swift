import SwiftUI

enum TextMode: String {
    case original = "原文"
    case easy = "やさしい日本語"
}

@Observable
final class ReadingViewModel {
    let work: Work
    var currentIndex: Int = 0
    var showVibes: Bool = false
    var showEmotions: Bool = false
    var selectedGlossary: GlossaryEntry?
    var isCompleted: Bool = false
    var textMode: TextMode = .original

    private let store = StoreManager.shared

    var currentSegment: TextSegment {
        work.segments[currentIndex]
    }

    var displayText: String {
        switch textMode {
        case .original: return currentSegment.originalText
        case .easy: return currentSegment.easyText
        }
    }

    var progress: Double {
        Double(currentIndex + 1) / Double(work.segments.count)
    }

    var progressText: String {
        "\(currentIndex + 1)/\(work.segments.count)"
    }

    init(work: Work) {
        self.work = work
        let saved = store.getProgress(for: work.id)
        if saved.currentIndex < work.segments.count && !saved.completed {
            self.currentIndex = saved.currentIndex
        }
    }

    func toggleTextMode() {
        textMode = textMode == .original ? .easy : .original
    }

    func next() {
        if currentIndex >= work.segments.count - 1 {
            store.saveProgress(ReadingProgress(
                workId: work.id,
                currentIndex: work.segments.count,
                completed: true
            ))
            isCompleted = true
        } else {
            currentIndex += 1
            showVibes = false
            showEmotions = false
            selectedGlossary = nil
            store.saveProgress(ReadingProgress(
                workId: work.id,
                currentIndex: currentIndex,
                completed: false
            ))
        }
    }

    func reset() {
        currentIndex = 0
        showVibes = false
        showEmotions = false
        selectedGlossary = nil
        isCompleted = false
        store.saveProgress(ReadingProgress(
            workId: work.id,
            currentIndex: 0,
            completed: false
        ))
    }
}
