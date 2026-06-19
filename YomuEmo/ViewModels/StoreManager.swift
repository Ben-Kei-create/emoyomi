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
    private let quotesKey = "emoyomi_quotes"
    private let pollVotesKey = "emoyomi_poll_votes"
    private let achievementsKey = "emoyomi_achievements"
    private let streakKey = "emoyomi_streak"

    // MARK: - Premium & Favorites

    var isPremium: Bool {
        get { UserDefaults.standard.bool(forKey: premiumKey) }
        set { UserDefaults.standard.set(newValue, forKey: premiumKey) }
    }

    var favorites: [String] {
        get { UserDefaults.standard.stringArray(forKey: favoritesKey) ?? [] }
        set { UserDefaults.standard.set(newValue, forKey: favoritesKey) }
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

    // MARK: - Reading Progress

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

    // MARK: - Saved Quotes

    var savedQuotes: [SavedQuote] {
        get {
            guard let data = UserDefaults.standard.data(forKey: quotesKey),
                  let quotes = try? JSONDecoder().decode([SavedQuote].self, from: data)
            else { return [] }
            return quotes
        }
        set {
            if let data = try? JSONEncoder().encode(newValue) {
                UserDefaults.standard.set(data, forKey: quotesKey)
            }
        }
    }

    func saveQuote(_ quote: SavedQuote) {
        var quotes = savedQuotes
        guard !quotes.contains(where: { $0.text == quote.text && $0.workId == quote.workId }) else { return }
        quotes.insert(quote, at: 0)
        savedQuotes = quotes
    }

    func removeQuote(_ quote: SavedQuote) {
        savedQuotes.removeAll { $0.id == quote.id }
    }

    func randomQuote() -> SavedQuote? {
        savedQuotes.randomElement()
    }

    // MARK: - Polls

    func hasVoted(pollId: String) -> Bool {
        let votes = UserDefaults.standard.stringArray(forKey: pollVotesKey) ?? []
        return votes.contains(pollId)
    }

    func recordVote(pollId: String) {
        var votes = UserDefaults.standard.stringArray(forKey: pollVotesKey) ?? []
        votes.append(pollId)
        UserDefaults.standard.set(votes, forKey: pollVotesKey)
    }

    // MARK: - Reading Stats

    var completedWorkCount: Int {
        WorksData.all.filter { getProgress(for: $0.id).completed }.count
    }

    var completedAuthorCount: Int {
        let completedWorkIds = Set(WorksData.all.filter { getProgress(for: $0.id).completed }.map(\.authorId))
        return completedWorkIds.count
    }

    var currentlyReading: [Work] {
        WorksData.all.filter { work in
            let progress = getProgress(for: work.id)
            return progress.currentIndex > 0 && !progress.completed
        }
    }

    func allWorksCompleted(by authorId: String) -> Bool {
        let authorWorks = WorksData.all.filter { $0.authorId == authorId }
        return !authorWorks.isEmpty && authorWorks.allSatisfy { getProgress(for: $0.id).completed }
    }

    // MARK: - Achievements

    var unlockedAchievementIds: [String] {
        get { UserDefaults.standard.stringArray(forKey: achievementsKey) ?? [] }
        set { UserDefaults.standard.set(newValue, forKey: achievementsKey) }
    }

    func isAchievementUnlocked(_ id: String) -> Bool {
        unlockedAchievementIds.contains(id)
    }

    @discardableResult
    func unlockAchievement(_ id: String) -> Bool {
        guard !isAchievementUnlocked(id) else { return false }
        var ids = unlockedAchievementIds
        ids.append(id)
        unlockedAchievementIds = ids
        return true
    }

    @discardableResult
    func checkAchievements() -> [Achievement] {
        var newlyUnlocked: [Achievement] = []

        let checks: [(String, Bool)] = [
            ("first-complete", completedWorkCount >= 1),
            ("three-complete", completedWorkCount >= 3),
            ("all-complete", completedWorkCount >= WorksData.all.count),
            ("first-quote", savedQuotes.count >= 1),
            ("ten-quotes", savedQuotes.count >= 10),
            ("twentyfive-quotes", savedQuotes.count >= 25),
            ("streak-3", streak.longestStreak >= 3),
            ("streak-7", streak.longestStreak >= 7),
            ("streak-30", streak.longestStreak >= 30),
            ("author-dazai", allWorksCompleted(by: "dazai")),
            ("author-akutagawa", allWorksCompleted(by: "akutagawa")),
            ("author-natsume", allWorksCompleted(by: "natsume")),
            ("author-miyazawa", allWorksCompleted(by: "miyazawa")),
        ]

        for (id, condition) in checks {
            if condition && unlockAchievement(id) {
                if let achievement = AchievementsData.find(by: id) {
                    newlyUnlocked.append(achievement)
                }
            }
        }

        return newlyUnlocked
    }

    // MARK: - Reading Streak

    var streak: ReadingStreak {
        get {
            guard let data = UserDefaults.standard.data(forKey: streakKey),
                  let s = try? JSONDecoder().decode(ReadingStreak.self, from: data)
            else { return ReadingStreak() }
            return s
        }
        set {
            if let data = try? JSONEncoder().encode(newValue) {
                UserDefaults.standard.set(data, forKey: streakKey)
            }
        }
    }

    func recordDailyReading() {
        var s = streak
        s.recordReading()
        streak = s
    }

    private init() {}
}
