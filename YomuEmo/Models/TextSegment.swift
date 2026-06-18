import Foundation

struct TextSegment: Identifiable {
    let id = UUID()
    let text: String
    let modernText: String
    let vibes: String
    let emotions: [EmotionTag: Int]
    var glossary: [GlossaryEntry] = []
}
