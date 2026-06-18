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
        case emotion = "感情"
        case streak = "継続"

        var color: Color {
            switch self {
            case .reading: return DS.Colors.accentIndigo
            case .collection: return DS.Colors.accentWarm
            case .emotion: return DS.Colors.accentPink
            case .streak: return Color(hex: "10b981")
            }
        }
    }
}

struct AchievementsData {
    static let all: [Achievement] = [
        Achievement(id: "first-segment", title: "はじめの一歩", description: "はじめてのセグメントを読んだ", icon: "📖", category: .reading),
        Achievement(id: "first-complete", title: "読了マスター", description: "はじめての作品を読了した", icon: "📚", category: .reading),
        Achievement(id: "all-complete", title: "全作品制覇", description: "すべての作品を読了した", icon: "🏅", category: .reading),
        Achievement(id: "three-modes", title: "三刀流", description: "3つの読書モードをすべて使った", icon: "⚔️", category: .reading),

        Achievement(id: "first-quote", title: "名言ハンター", description: "はじめての名言を保存した", icon: "💬", category: .collection),
        Achievement(id: "ten-quotes", title: "名言コレクター", description: "名言を10個保存した", icon: "📝", category: .collection),
        Achievement(id: "twentyfive-quotes", title: "名言マスター", description: "名言を25個保存した", icon: "📜", category: .collection),
        Achievement(id: "first-poll", title: "世論調査員", description: "はじめての投票に参加した", icon: "🗳️", category: .collection),

        Achievement(id: "first-emotion", title: "感情の目覚め", description: "はじめての感情を発見した", icon: "🌈", category: .emotion),
        Achievement(id: "seven-emotions", title: "感情パレット", description: "7つの感情を発見した", icon: "🎨", category: .emotion),
        Achievement(id: "all-emotions", title: "感情コンプリート", description: "すべての感情を発見した", icon: "🌟", category: .emotion),
        Achievement(id: "max-intensity", title: "感情の深淵", description: "感情の強度が最大に達した", icon: "💯", category: .emotion),

        Achievement(id: "streak-3", title: "三日坊主卒業", description: "3日連続で読書した", icon: "🔥", category: .streak),
        Achievement(id: "streak-7", title: "一週間の習慣", description: "7日連続で読書した", icon: "⚡", category: .streak),
        Achievement(id: "streak-30", title: "月の読書家", description: "30日連続で読書した", icon: "🌙", category: .streak),
    ]

    static func find(by id: String) -> Achievement? {
        all.first { $0.id == id }
    }
}
