import SwiftUI

struct StreakCard: View {
    let streak: ReadingStreak

    var body: some View {
        HStack(spacing: DS.Spacing.lg) {
            VStack(spacing: DS.Spacing.xs) {
                Text(streak.streakAlive && streak.currentStreak > 0
                    ? "\(streak.currentStreak)" : "0")
                    .font(DS.Fonts.serifBold(32))
                    .foregroundStyle(streak.currentStreak >= 3
                        ? DS.Gradients.streakFire
                        : LinearGradient(colors: [DS.Colors.textPrimary], startPoint: .top, endPoint: .bottom))

                Text("日連続")
                    .font(DS.Fonts.caption())
                    .foregroundColor(DS.Colors.textSecondary)
            }

            VStack(alignment: .leading, spacing: DS.Spacing.sm) {
                HStack(spacing: DS.Spacing.md) {
                    statItem(value: "\(streak.longestStreak)", label: "最長")
                    statItem(value: "\(streak.totalDaysRead)", label: "累計")
                }

                weekDots
            }
        }
        .frame(maxWidth: .infinity)
        .padding(DS.Spacing.xl)
        .glassCard()
    }

    private func statItem(value: String, label: String) -> some View {
        VStack(spacing: 2) {
            Text(value)
                .font(DS.Fonts.body(16, weight: .bold))
                .foregroundColor(DS.Colors.textPrimary)
            Text(label)
                .font(DS.Fonts.caption())
                .foregroundColor(DS.Colors.textSecondary)
        }
    }

    private var weekDots: some View {
        let formatter = Self.weekFormatter
        return HStack(spacing: DS.Spacing.xs) {
            ForEach(0..<7, id: \.self) { dayOffset in
                let date = Calendar.current.date(byAdding: .day, value: -6 + dayOffset, to: Date())!
                let dateStr = formatter.string(from: date)

                Circle()
                    .fill(streak.readDates.contains(dateStr) ? DS.Colors.accentIndigo : Color.white.opacity(0.1))
                    .frame(width: 10, height: 10)
            }
        }
    }

    private static var weekFormatter: DateFormatter {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd"
        f.locale = Locale(identifier: "en_US_POSIX")
        return f
    }
}

#Preview {
    var streak = ReadingStreak()
    streak.currentStreak = 5
    streak.longestStreak = 12
    streak.totalDaysRead = 23
    return StreakCard(streak: streak)
        .padding(DS.Spacing.xl)
        .background(DS.Colors.bgPrimary)
}
