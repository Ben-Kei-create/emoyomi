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
    private let xpKey = "emoyomi_xp"
    private let emotionCollectionKey = "emoyomi_emotion_collection"
    private let achievementsKey = "emoyomi_achievements"
    private let streakKey = "emoyomi_streak"
    private let segmentsReadKey = "emoyomi_segments_read"
    private let modesUsedKey = "emoyomi_modes_used"

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

    // MARK: - Quotes

    var savedQuotes: [FavoriteQuote] {
        get {
            guard let data = UserDefaults.standard.data(forKey: quotesKey),
                  let quotes = try? JSONDecoder().decode([FavoriteQuote].self, from: data)
            else { return [] }
            return quotes
        }
        set {
            if let data = try? JSONEncoder().encode(newValue) {
                UserDefaults.standard.set(data, forKey: quotesKey)
            }
        }
    }

    func saveQuote(_ quote: FavoriteQuote) {
        var quotes = savedQuotes
        guard !quotes.contains(where: { $0.text == quote.text && $0.workTitle == quote.workTitle }) else { return }
        quotes.insert(quote, at: 0)
        savedQuotes = quotes
    }

    func removeQuote(_ quote: FavoriteQuote) {
        savedQuotes.removeAll { $0.id == quote.id }
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

    // MARK: - XP & Level

    var totalXP: Int {
        get { UserDefaults.standard.integer(forKey: xpKey) }
        set { UserDefaults.standard.set(newValue, forKey: xpKey) }
    }

    var currentLevel: ReaderLevel {
        ReaderLevel.current(for: totalXP)
    }

    @discardableResult
    func addXP(_ source: XPSource) -> Int {
        let amount = source.amount
        totalXP += amount
        return amount
    }

    // MARK: - Segments Read

    var totalSegmentsRead: Int {
        get { UserDefaults.standard.integer(forKey: segmentsReadKey) }
        set { UserDefaults.standard.set(newValue, forKey: segmentsReadKey) }
    }

    func incrementSegmentsRead() {
        totalSegmentsRead += 1
    }

    // MARK: - Reading Modes Used

    var modesUsed: [String] {
        get { UserDefaults.standard.stringArray(forKey: modesUsedKey) ?? [] }
        set { UserDefaults.standard.set(newValue, forKey: modesUsedKey) }
    }

    func recordModeUsed(_ mode: ReadingMode) {
        var modes = modesUsed
        if !modes.contains(mode.rawValue) {
            modes.append(mode.rawValue)
            modesUsed = modes
        }
    }

    // MARK: - Emotion Collection

    var emotionCollection: [EmotionCollectionEntry] {
        get {
            guard let data = UserDefaults.standard.data(forKey: emotionCollectionKey),
                  let entries = try? JSONDecoder().decode([EmotionCollectionEntry].self, from: data)
            else { return [] }
            return entries
        }
        set {
            if let data = try? JSONEncoder().encode(newValue) {
                UserDefaults.standard.set(data, forKey: emotionCollectionKey)
            }
        }
    }

    var discoveredEmotionCount: Int {
        emotionCollection.count
    }

    @discardableResult
    func recordEmotionEncounter(tag: EmotionTag, intensity: Int, workId: String) -> Bool {
        var collection = emotionCollection
        let isNew: Bool

        if let index = collection.firstIndex(where: { $0.emotionRawValue == tag.rawValue }) {
            collection[index].encounters += 1
            collection[index].maxIntensity = max(collection[index].maxIntensity, intensity)
            collection[index].totalIntensity += intensity
            if !collection[index].sourceWorkIds.contains(workId) {
                collection[index].sourceWorkIds.append(workId)
            }
            isNew = false
        } else {
            let entry = EmotionCollectionEntry(
                emotionRawValue: tag.rawValue,
                encounters: 1,
                maxIntensity: intensity,
                totalIntensity: intensity,
                firstEncountered: Date(),
                sourceWorkIds: [workId]
            )
            collection.append(entry)
            isNew = true
        }

        emotionCollection = collection
        return isNew
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

    func checkAchievements() -> [Achievement] {
        var newlyUnlocked: [Achievement] = []

        let checks: [(String, Bool)] = [
            ("first-segment", totalSegmentsRead >= 1),
            ("first-complete", completedWorkCount >= 1),
            ("all-complete", completedWorkCount >= WorksData.all.count),
            ("three-modes", modesUsed.count >= 3),
            ("first-quote", savedQuotes.count >= 1),
            ("ten-quotes", savedQuotes.count >= 10),
            ("twentyfive-quotes", savedQuotes.count >= 25),
            ("first-poll", (UserDefaults.standard.stringArray(forKey: pollVotesKey) ?? []).count >= 1),
            ("first-emotion", discoveredEmotionCount >= 1),
            ("seven-emotions", discoveredEmotionCount >= 7),
            ("all-emotions", discoveredEmotionCount >= EmotionTag.allCases.count),
            ("max-intensity", emotionCollection.contains(where: { $0.maxIntensity >= 95 })),
            ("streak-3", streak.longestStreak >= 3),
            ("streak-7", streak.longestStreak >= 7),
            ("streak-30", streak.longestStreak >= 30),
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

    var completedWorkCount: Int {
        WorksData.all.filter { getProgress(for: $0.id).completed }.count
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
        let wasActiveToday = s.isActiveToday
        s.recordReading()
        streak = s

        if !wasActiveToday {
            addXP(.dailyReading)
            if s.currentStreak > 1 {
                addXP(.streakBonus(days: s.currentStreak))
            }
        }
    }

    private init() {}
}
