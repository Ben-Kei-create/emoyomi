import Foundation

struct ReaderLevel {
    let level: Int
    let title: String
    let requiredXP: Int
    let icon: String

    static let levels: [ReaderLevel] = [
        ReaderLevel(level: 1, title: "文学のたまご", requiredXP: 0, icon: "🥚"),
        ReaderLevel(level: 2, title: "活字の冒険者", requiredXP: 100, icon: "📖"),
        ReaderLevel(level: 3, title: "感情の旅人", requiredXP: 300, icon: "🎒"),
        ReaderLevel(level: 4, title: "言葉の収集家", requiredXP: 600, icon: "🔮"),
        ReaderLevel(level: 5, title: "文豪の弟子", requiredXP: 1000, icon: "🎓"),
        ReaderLevel(level: 6, title: "感情マスター", requiredXP: 1500, icon: "🌟"),
        ReaderLevel(level: 7, title: "文学の達人", requiredXP: 2200, icon: "👑"),
        ReaderLevel(level: 8, title: "伝説の読書家", requiredXP: 3000, icon: "⭐"),
        ReaderLevel(level: 9, title: "文学の賢者", requiredXP: 4000, icon: "🏆"),
        ReaderLevel(level: 10, title: "永遠の文豪", requiredXP: 5500, icon: "📜"),
    ]

    static func current(for xp: Int) -> ReaderLevel {
        levels.last(where: { $0.requiredXP <= xp }) ?? levels[0]
    }

    static func next(for xp: Int) -> ReaderLevel? {
        let current = current(for: xp)
        return levels.first(where: { $0.level == current.level + 1 })
    }

    static func progressToNext(for xp: Int) -> Double {
        let current = current(for: xp)
        guard let next = next(for: xp) else { return 1.0 }
        let range = next.requiredXP - current.requiredXP
        let progress = xp - current.requiredXP
        return Double(progress) / Double(range)
    }
}

enum XPSource {
    case readSegment
    case completeWork
    case saveQuote
    case votePoll
    case discoverEmotion
    case dailyReading
    case streakBonus(days: Int)

    var amount: Int {
        switch self {
        case .readSegment: return 10
        case .completeWork: return 100
        case .saveQuote: return 15
        case .votePoll: return 10
        case .discoverEmotion: return 25
        case .dailyReading: return 20
        case .streakBonus(let days): return min(days * 5, 50)
        }
    }

    var label: String {
        switch self {
        case .readSegment: return "セグメント読了"
        case .completeWork: return "作品読了"
        case .saveQuote: return "名言保存"
        case .votePoll: return "投票参加"
        case .discoverEmotion: return "感情発見"
        case .dailyReading: return "今日の読書"
        case .streakBonus: return "連続ボーナス"
        }
    }
}
