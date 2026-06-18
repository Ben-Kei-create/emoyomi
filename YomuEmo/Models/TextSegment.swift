import Foundation

struct TextSegment: Identifiable {
    let id = UUID()
    let originalText: String
    let easyText: String
    let glossaryEntries: [GlossaryEntry]
    let vibesSummary: String
    let emotionScores: [EmotionTag: Int]

    init(
        originalText: String,
        easyText: String,
        glossaryEntries: [GlossaryEntry] = [],
        vibesSummary: String,
        emotionScores: [EmotionTag: Int]
    ) {
        self.originalText = originalText
        self.easyText = easyText
        self.glossaryEntries = glossaryEntries
        self.vibesSummary = vibesSummary
        self.emotionScores = emotionScores
    }
}
