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
    let polls: [Poll]

    struct Afterword {
        let theme: String
        let point: String
        let modern: String
    }

    init(
        id: String,
        title: String,
        authorId: String,
        authorName: String,
        tags: [EmotionTag],
        readTime: String,
        isPremium: Bool,
        coverEmoji: String,
        description: String,
        afterword: Afterword,
        segments: [TextSegment],
        polls: [Poll] = []
    ) {
        self.id = id
        self.title = title
        self.authorId = authorId
        self.authorName = authorName
        self.tags = tags
        self.readTime = readTime
        self.isPremium = isPremium
        self.coverEmoji = coverEmoji
        self.description = description
        self.afterword = afterword
        self.segments = segments
        self.polls = polls
    }
}
