import Foundation

struct GlossaryEntry: Identifiable {
    let id = UUID()
    let word: String
    let reading: String
    let meaning: String
    let easyMeaning: String
    let vibes: String

    init(word: String, reading: String, meaning: String, easyMeaning: String? = nil, vibes: String) {
        self.word = word
        self.reading = reading
        self.meaning = meaning
        self.easyMeaning = easyMeaning ?? meaning
        self.vibes = vibes
    }
}
