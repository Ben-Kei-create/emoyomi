import Foundation

enum AuthorsData {
    static let all: [Author] = [
        Author(
            id: "dazai",
            name: "太宰治",
            bio: "人間やるの疲れがちな文豪。自分が嫌いなのに誰かに愛されたい矛盾を抱えて生きた人。",
            tags: [.自己嫌悪, .承認欲求, .孤独],
            workIds: ["ningen-shikkaku", "hashire-melos"],
            born: "1909",
            died: "1948",
            icon: "🖋️"
        ),
        Author(
            id: "akutagawa",
            name: "芥川龍之介",
            bio: "知性で武装した繊細すぎるメンタルの持ち主。短編の天才だけど、生きるのは下手だった。",
            tags: [.不安, .嫉妬, .絶望],
            workIds: ["rashomon", "kumo-no-ito"],
            born: "1892",
            died: "1927",
            icon: "📚"
        ),
        Author(
            id: "natsume",
            name: "夏目漱石",
            bio: "明治のインテリ代表。人付き合い苦手なのに人間観察は超一流。猫視点で社会を斬る。",
            tags: [.孤独, .郷愁, .諦念],
            workIds: ["kokoro"],
            born: "1867",
            died: "1916",
            icon: "🐱"
        ),
        Author(
            id: "miyazawa",
            name: "宮沢賢治",
            bio: "生前はほぼ無名。自然と宇宙とやさしさを描いた孤独な理想主義者。",
            tags: [.希望, .孤独, .青春],
            workIds: ["gingatetsudo"],
            born: "1896",
            died: "1933",
            icon: "🌌"
        ),
    ]

    static func find(by id: String) -> Author? {
        all.first { $0.id == id }
    }
}
