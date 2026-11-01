import Foundation

struct Author: Identifiable {
    let id: String
    let name: String
    let bio: String
    let tags: [EmotionTag]
    let workIds: [String]
    let born: String
    let died: String
    let icon: String
}
