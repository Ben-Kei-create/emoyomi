import SwiftUI

struct Achievement: Identifiable {
    let id: String
    let title: String
    let description: String
    let icon: String
    let category: AchievementCategory

    enum AchievementCategory: String, CaseIterable {
        case reading = "読書"
        case collection = "収集"
        case streak = "継続"
        case author = "文豪"

        var color: Color {
            switch self {
            case .reading: return DS.Colors.accentIndigo
            case .collection: return DS.Colors.accentWarm
            case .streak: return Color(hex: "10b981")
            case .author: return DS.Colors.accentPink
            }
        }
    }
}

struct AchievementsData {
    static let all: [Achievement] = [
        Achievement(id: "first-complete", title: "はじめての一冊", description: "はじめての作品を読了した", icon: "📖", category: .reading),
        Achievement(id: "three-complete", title: "三冊読破", description: "3つの作品を読了した", icon: "📚", category: .reading),
        Achievement(id: "all-complete", title: "全作品制覇", description: "すべての作品を読了した", icon: "🏅", category: .reading),

        Achievement(id: "first-quote", title: "ことばの記録", description: "はじめての一文を保存した", icon: "✍️", category: .collection),
        Achievement(id: "ten-quotes", title: "名言収集家", description: "一文を10個保存した", icon: "📝", category: .collection),
        Achievement(id: "twentyfive-quotes", title: "文学の宝箱", description: "一文を25個保存した", icon: "📜", category: .collection),

        Achievement(id: "streak-3", title: "三日坊主卒業", description: "3日連続で読書した", icon: "🔥", category: .streak),
        Achievement(id: "streak-7", title: "七日連続", description: "7日連続で読書した", icon: "⚡", category: .streak),
        Achievement(id: "streak-30", title: "月の読書家", description: "30日連続で読書した", icon: "🌙", category: .streak),

        Achievement(id: "author-dazai", title: "太宰研究家", description: "太宰治の全作品を読了した", icon: "🖋️", category: .author),
        Achievement(id: "author-akutagawa", title: "芥川研究家", description: "芥川龍之介の全作品を読了した", icon: "📚", category: .author),
        Achievement(id: "author-natsume", title: "漱石研究家", description: "夏目漱石の全作品を読了した", icon: "🐱", category: .author),
        Achievement(id: "author-miyazawa", title: "賢治研究家", description: "宮沢賢治の全作品を読了した", icon: "🌌", category: .author),
    ]

    static func find(by id: String) -> Achievement? {
        all.first { $0.id == id }
    }
}
