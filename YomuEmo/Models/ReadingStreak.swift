import Foundation

struct ReadingStreak: Codable {
    var currentStreak: Int
    var longestStreak: Int
    var lastReadDate: String?
    var totalDaysRead: Int
    var readDates: [String]

    init() {
        self.currentStreak = 0
        self.longestStreak = 0
        self.lastReadDate = nil
        self.totalDaysRead = 0
        self.readDates = []
    }

    private static var dateFormatter: DateFormatter {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd"
        f.locale = Locale(identifier: "en_US_POSIX")
        return f
    }

    mutating func recordReading() {
        let today = Self.dateFormatter.string(from: Date())
        guard lastReadDate != today else { return }

        if let last = lastReadDate,
           let lastDate = Self.dateFormatter.date(from: last),
           let todayDate = Self.dateFormatter.date(from: today) {
            let dayDiff = Calendar.current.dateComponents([.day], from: lastDate, to: todayDate).day ?? 0
            currentStreak = dayDiff == 1 ? currentStreak + 1 : 1
        } else {
            currentStreak = 1
        }

        longestStreak = max(longestStreak, currentStreak)
        lastReadDate = today
        totalDaysRead += 1

        if !readDates.contains(today) {
            readDates.append(today)
            if readDates.count > 90 {
                readDates.removeFirst()
            }
        }
    }

    var isActiveToday: Bool {
        lastReadDate == Self.dateFormatter.string(from: Date())
    }

    var streakAlive: Bool {
        guard let last = lastReadDate,
              let lastDate = Self.dateFormatter.date(from: last) else { return false }
        let dayDiff = Calendar.current.dateComponents([.day], from: lastDate, to: Date()).day ?? 0
        return dayDiff <= 1
    }
}
