import Foundation

struct GlossaryEntry: Identifiable {
    let id = UUID()
    let word: String
    let reading: String
    let meaning: String
    let vibes: String
}
