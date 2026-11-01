import Foundation

struct EmotionDiagnosisResult {
    let work: Work
    let matchedEmotions: [EmotionTag: Int]
    let reason: String
}
