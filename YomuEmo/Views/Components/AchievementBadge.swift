import SwiftUI

struct AchievementBadge: View {
    let achievement: Achievement
    let isUnlocked: Bool

    var body: some View {
        VStack(spacing: DS.Spacing.sm) {
            ZStack {
                Circle()
                    .fill(isUnlocked
                        ? achievement.category.color.opacity(0.2)
                        : Color.white.opacity(0.05))
                    .frame(width: 56, height: 56)

                if isUnlocked {
                    Circle()
                        .strokeBorder(achievement.category.color.opacity(0.5), lineWidth: 2)
                        .frame(width: 56, height: 56)
                }

                Text(achievement.icon)
                    .font(.system(size: 24))
                    .grayscale(isUnlocked ? 0 : 1)
                    .opacity(isUnlocked ? 1 : 0.3)
            }

            Text(achievement.title)
                .font(DS.Fonts.caption())
                .foregroundColor(isUnlocked ? DS.Colors.textPrimary : DS.Colors.textSecondary.opacity(0.5))
                .lineLimit(1)
        }
        .frame(width: 72)
    }
}

#Preview {
    HStack(spacing: DS.Spacing.lg) {
        AchievementBadge(
            achievement: AchievementsData.all[0],
            isUnlocked: true
        )
        AchievementBadge(
            achievement: AchievementsData.all[1],
            isUnlocked: false
        )
    }
    .padding(DS.Spacing.xl)
    .background(DS.Colors.bgPrimary)
}
