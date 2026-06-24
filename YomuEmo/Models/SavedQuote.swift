import Foundation

struct SavedQuote: Identifiable, Codable, Equatable {
    let id: UUID
    let text: String
    let workId: String
    let workTitle: String
    let authorId: String
    let authorName: String
    let savedAt: Date

    init(text: String, workId: String, workTitle: String, authorId: String, authorName: String) {
        self.id = UUID()
        self.text = text
        self.workId = workId
        self.workTitle = workTitle
        self.authorId = authorId
        self.authorName = authorName
        self.savedAt = Date()
    }
}
