import Foundation

struct ReadingProgress: Codable {
    let workId: String
    var currentIndex: Int
    var completed: Bool
}

@Observable
final class StoreManager {
    static let shared = StoreManager()

    private let progressKey = "emoyomi_progress"
    private let premiumKey = "emoyomi_premium"
    private let favoritesKey = "emoyomi_favorites"

    var isPremium: Bool {
        get { UserDefaults.standard.bool(forKey: premiumKey) }
        set { UserDefaults.standard.set(newValue, forKey: premiumKey) }
    }

    var favorites: [String] {
        get { UserDefaults.standard.stringArray(forKey: favoritesKey) ?? [] }
        set { UserDefaults.standard.set(newValue, forKey: favoritesKey) }
    }

    func getProgress(for workId: String) -> ReadingProgress {
        guard let data = UserDefaults.standard.data(forKey: "\(progressKey)_\(workId)"),
              let progress = try? JSONDecoder().decode(ReadingProgress.self, from: data)
        else {
            return ReadingProgress(workId: workId, currentIndex: 0, completed: false)
        }
        return progress
    }

    func saveProgress(_ progress: ReadingProgress) {
        if let data = try? JSONEncoder().encode(progress) {
            UserDefaults.standard.set(data, forKey: "\(progressKey)_\(progress.workId)")
        }
    }

    func toggleFavorite(_ workId: String) {
        if favorites.contains(workId) {
            favorites.removeAll { $0 == workId }
        } else {
            favorites.append(workId)
        }
    }

    func isFavorite(_ workId: String) -> Bool {
        favorites.contains(workId)
    }

    private init() {}
}
