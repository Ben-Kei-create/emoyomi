import Foundation

struct FavoriteQuote: Identifiable, Codable, Equatable {
    let id: UUID
    let text: String
    let workTitle: String
    let authorName: String
    let savedDate: Date

    init(text: String, workTitle: String, authorName: String) {
        self.id = UUID()
        self.text = text
        self.workTitle = workTitle
        self.authorName = authorName
        self.savedDate = Date()
    }
}
