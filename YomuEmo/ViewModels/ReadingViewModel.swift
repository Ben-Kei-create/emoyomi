import SwiftUI

// HOW content is presented
enum ReadingMode: String, CaseIterable {
    case lyric = "リリック"
    case cinema = "シネマ"
    case focus = "フォーカス"

    var icon: String {
        switch self {
        case .lyric: return "text.aligncenter"
        case .cinema: return "film"
        case .focus: return "eye"
        }
    }
}

// WHICH version of the text is displayed
enum TextMode: String, CaseIterable {
    case original = "原文"
    case modern = "現代語"
}

// HOW word explanations are presented
enum GlossaryMode: String, CaseIterable {
    case literature = "辞書"
    case easy = "やさしい"
    case emo = "エモ"
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

enum AutoPlaySpeed: String, CaseIterable {
    case off = "Off"
    case sec2 = "2秒"
    case sec3 = "3秒"
    case sec5 = "5秒"
    case sec8 = "8秒"

    var interval: TimeInterval? {
        switch self {
        case .off: return nil
        case .sec2: return 2
        case .sec3: return 3
        case .sec5: return 5
        case .sec8: return 8
        }
    }
}

@Observable
final class ReadingViewModel {
    let work: Work
    var currentIndex: Int = 0
    var selectedGlossary: GlossaryEntry?
    var isCompleted: Bool = false
    var readingMode: ReadingMode = .lyric
    var textMode: TextMode = .original
    var glossaryMode: GlossaryMode = .literature
    var quoteSaved: Bool = false
    var showSaveToast: Bool = false
    var showMenu: Bool = false
    var fontSize: ReadingFontSize = .medium
    var backgroundStyle: ReadingBackground = .paper
    var autoPlaySpeed: AutoPlaySpeed = .off
    var cinemaPaused: Bool = false
    var focusControlsVisible: Bool = true

    private let store = StoreManager.shared
    private var autoPlayTimer: Timer?
    private var focusHideTimer: Timer?

    var currentSegment: TextSegment {
        work.segments[currentIndex]
    }

    var previousSegment: TextSegment? {
        guard currentIndex > 0 else { return nil }
        return work.segments[currentIndex - 1]
    }

    var nextSegment: TextSegment? {
        guard currentIndex < work.segments.count - 1 else { return nil }
        return work.segments[currentIndex + 1]
    }

    func displayText(for segment: TextSegment) -> String {
        switch textMode {
        case .original: return segment.originalText
        case .modern: return segment.easyText
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
        if let raw = UserDefaults.standard.string(forKey: "emoyomi_readingMode"),
           let mode = ReadingMode(rawValue: raw) {
            self.readingMode = mode
        }
        if let raw = UserDefaults.standard.string(forKey: "emoyomi_textMode"),
           let mode = TextMode(rawValue: raw) {
            self.textMode = mode
        }
        if let raw = UserDefaults.standard.string(forKey: "emoyomi_glossaryMode"),
           let mode = GlossaryMode(rawValue: raw) {
            self.glossaryMode = mode
        }
        if let raw = UserDefaults.standard.string(forKey: "emoyomi_fontSize"),
           let size = ReadingFontSize(rawValue: raw) {
            self.fontSize = size
        }
        if let raw = UserDefaults.standard.string(forKey: "emoyomi_background"),
           let bg = ReadingBackground(rawValue: raw) {
            self.backgroundStyle = bg
        }
        if let raw = UserDefaults.standard.string(forKey: "emoyomi_autoPlay"),
           let speed = AutoPlaySpeed(rawValue: raw) {
            self.autoPlaySpeed = speed
        }
    }

    deinit {
        autoPlayTimer?.invalidate()
        focusHideTimer?.invalidate()
    }

    // MARK: - Setters with persistence

    func setReadingMode(_ mode: ReadingMode) {
        readingMode = mode
        UserDefaults.standard.set(mode.rawValue, forKey: "emoyomi_readingMode")
        if mode == .cinema { cinemaPaused = false }
        restartAutoPlayIfNeeded()
        if mode == .focus { resetFocusHideTimer() }
    }

    func setTextMode(_ mode: TextMode) {
        textMode = mode
        UserDefaults.standard.set(mode.rawValue, forKey: "emoyomi_textMode")
    }

    func setGlossaryMode(_ mode: GlossaryMode) {
        glossaryMode = mode
        UserDefaults.standard.set(mode.rawValue, forKey: "emoyomi_glossaryMode")
    }

    func setFontSize(_ size: ReadingFontSize) {
        fontSize = size
        UserDefaults.standard.set(size.rawValue, forKey: "emoyomi_fontSize")
    }

    func setBackground(_ bg: ReadingBackground) {
        backgroundStyle = bg
        UserDefaults.standard.set(bg.rawValue, forKey: "emoyomi_background")
    }

    func setAutoPlay(_ speed: AutoPlaySpeed) {
        autoPlaySpeed = speed
        UserDefaults.standard.set(speed.rawValue, forKey: "emoyomi_autoPlay")
        restartAutoPlayIfNeeded()
    }

    // MARK: - Auto Play

    func restartAutoPlayIfNeeded() {
        autoPlayTimer?.invalidate()
        autoPlayTimer = nil
        guard let interval = autoPlaySpeed.interval else { return }
        if readingMode == .cinema && cinemaPaused { return }
        autoPlayTimer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { [weak self] _ in
            DispatchQueue.main.async {
                self?.next()
            }
        }
    }

    func stopAutoPlay() {
        autoPlayTimer?.invalidate()
        autoPlayTimer = nil
    }

    // MARK: - Focus mode

    func resetFocusHideTimer() {
        focusControlsVisible = true
        focusHideTimer?.invalidate()
        focusHideTimer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false) { [weak self] _ in
            DispatchQueue.main.async {
                withAnimation(.easeOut(duration: 0.5)) {
                    self?.focusControlsVisible = false
                }
            }
        }
    }

    func showFocusControls() {
        if readingMode == .focus {
            resetFocusHideTimer()
        }
    }

    // MARK: - Cinema mode

    func toggleCinemaPause() {
        cinemaPaused.toggle()
        if cinemaPaused {
            stopAutoPlay()
        } else {
            restartAutoPlayIfNeeded()
        }
    }

    // MARK: - Navigation

    func next() {
        store.recordDailyReading()

        if currentIndex >= work.segments.count - 1 {
            stopAutoPlay()
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
            if readingMode == .focus { resetFocusHideTimer() }
            restartAutoPlayIfNeeded()
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
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
            withAnimation(.easeOut(duration: 0.3)) { self?.showSaveToast = false }
        }
    }
}
