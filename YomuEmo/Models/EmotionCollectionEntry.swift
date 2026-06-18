import Foundation

struct EmotionCollectionEntry: Codable, Identifiable {
    var id: String { emotionRawValue }
    let emotionRawValue: String
    var encounters: Int
    var maxIntensity: Int
    var totalIntensity: Int
    var firstEncountered: Date
    var sourceWorkIds: [String]

    var tag: EmotionTag? {
        EmotionTag(rawValue: emotionRawValue)
    }

    var averageIntensity: Int {
        encounters > 0 ? totalIntensity / encounters : 0
    }

    var masteryLevel: EmotionMastery {
        switch encounters {
        case 0: return .undiscovered
        case 1...3: return .encountered
        case 4...8: return .familiar
        default: return .mastered
        }
    }
}

enum EmotionMastery: String, Codable {
    case undiscovered = "未発見"
    case encountered = "出会い"
    case familiar = "理解"
    case mastered = "共鳴"

    var icon: String {
        switch self {
        case .undiscovered: return "─"
        case .encountered: return "芽"
        case .familiar: return "花"
        case .mastered: return "実"
        }
    }

    var opacity: Double {
        switch self {
        case .undiscovered: return 0.3
        case .encountered: return 0.6
        case .familiar: return 0.85
        case .mastered: return 1.0
        }
    }
}
