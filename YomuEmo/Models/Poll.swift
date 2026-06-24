import Foundation

struct PollOption: Identifiable {
    let id = UUID()
    let text: String
    let percentage: Int
}

struct Poll: Identifiable {
    let id = UUID()
    let question: String
    let options: [PollOption]
}
