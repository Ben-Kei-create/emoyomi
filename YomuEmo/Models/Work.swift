import Foundation

struct Work: Identifiable {
    let id: String
    let title: String
    let authorId: String
    let authorName: String
    let tags: [EmotionTag]
    let readTime: String
    let isPremium: Bool
    let coverEmoji: String
    let description: String
    let afterword: Afterword
    let segments: [TextSegment]

    struct Afterword {
        let theme: String
        let point: String
        let modern: String
    }
}
