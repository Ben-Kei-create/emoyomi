import SwiftUI

enum EmotionTag: String, CaseIterable, Codable, Identifiable {
    case 孤独
    case 不安
    case 嫉妬
    case 希望
    case 怒り
    case 恋愛
    case 罪悪感
    case 生きづらさ
    case 青春
    case 絶望
    case 自己嫌悪
    case 承認欲求
    case 郷愁
    case 諦念

    var id: String { rawValue }

    var color: Color {
        switch self {
        case .孤独: return Color(hex: "6366f1")
        case .不安: return Color(hex: "8b5cf6")
        case .嫉妬: return Color(hex: "10b981")
        case .希望: return Color(hex: "f59e0b")
        case .怒り: return Color(hex: "ef4444")
        case .恋愛: return Color(hex: "ec4899")
        case .罪悪感: return Color(hex: "6b7280")
        case .生きづらさ: return Color(hex: "78716c")
        case .青春: return Color(hex: "06b6d4")
        case .絶望: return Color(hex: "1e1b4b")
        case .自己嫌悪: return Color(hex: "7c3aed")
        case .承認欲求: return Color(hex: "f97316")
        case .郷愁: return Color(hex: "a78bfa")
        case .諦念: return Color(hex: "94a3b8")
        }
    }

    var emoji: String {
        switch self {
        case .孤独: return "🌙"
        case .不安: return "🌊"
        case .嫉妬: return "🐍"
        case .希望: return "🌅"
        case .怒り: return "🔥"
        case .恋愛: return "💕"
        case .罪悪感: return "⛓️"
        case .生きづらさ: return "🫠"
        case .青春: return "🌸"
        case .絶望: return "🕳️"
        case .自己嫌悪: return "🪞"
        case .承認欲求: return "📱"
        case .郷愁: return "🏚️"
        case .諦念: return "🍃"
        }
    }

    static let displayOrder: [EmotionTag] = [
        .孤独, .不安, .嫉妬, .希望, .怒り, .恋愛,
        .罪悪感, .生きづらさ, .青春, .絶望, .自己嫌悪, .承認欲求
    ]
}
