import Foundation

struct TextSegment: Identifiable {
    let id = UUID()
    let originalText: String
    let easyText: String
    let emoText: String
    let glossaryEntries: [GlossaryEntry]
    let vibesSummary: String
    let emotionScores: [EmotionTag: Int]
    let pollIndex: Int?

    init(
        originalText: String,
        easyText: String,
        emoText: String = "",
        glossaryEntries: [GlossaryEntry] = [],
        vibesSummary: String,
        emotionScores: [EmotionTag: Int],
        pollIndex: Int? = nil
    ) {
        self.originalText = originalText
        self.easyText = easyText
        self.emoText = emoText.isEmpty ? easyText : emoText
        self.glossaryEntries = glossaryEntries
        self.vibesSummary = vibesSummary
        self.emotionScores = emotionScores
        self.pollIndex = pollIndex
    }
}
