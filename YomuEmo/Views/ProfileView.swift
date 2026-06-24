import SwiftUI

struct ProfileView: View {
    @State private var store = StoreManager.shared

    var body: some View {
        ZStack {
            DS.Colors.bgPrimary.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {
                    headerSection
                    footprintsSection
                    streakSection
                    achievementsSection
                    premiumSection
                }
            }
        }
        .navigationBarHidden(true)
    }

    private var headerSection: some View {
        Text("マイページ")
            .font(DS.Fonts.serifBold(24))
            .foregroundColor(DS.Colors.textPrimary)
            .padding(.horizontal, DS.Spacing.xl)
            .padding(.top, DS.Spacing.lg)
            .padding(.bottom, DS.Spacing.xl)
    }

    private var footprintsSection: some View {
        VStack(alignment: .leading, spacing: DS.Spacing.md) {
            Text("読書の足あと")
                .sectionHeader()
                .padding(.horizontal, DS.Spacing.xl)

            HStack(spacing: DS.Spacing.md) {
                statCard(value: "\(store.completedWorkCount)", label: "読破\n作品", icon: "📚")
                statCard(value: "\(store.completedAuthorCount)", label: "読んだ\n作者", icon: "🖋️")
                statCard(value: "\(store.savedQuotes.count)", label: "保存した\n言葉", icon: "💬")
            }
            .padding(.horizontal, DS.Spacing.xl)

            if !store.currentlyReading.isEmpty {
                VStack(alignment: .leading, spacing: DS.Spacing.sm) {
                    Text("いま読んでいる作品")
                        .font(DS.Fonts.caption())
                        .foregroundColor(DS.Colors.textSecondary)
                        .padding(.horizontal, DS.Spacing.xl)

                    ForEach(store.currentlyReading) { work in
                        NavigationLink(destination: ReadingView(work: work)) {
                            HStack(spacing: DS.Spacing.md) {
                                Text(work.coverEmoji)
                                    .font(.system(size: 24))
                                Text(work.title)
                                    .font(DS.Fonts.body(14, weight: .medium))
                                    .foregroundColor(DS.Colors.textPrimary)
                                Spacer()
                                let progress = store.getProgress(for: work.id)
                                Text("\(progress.currentIndex)/\(work.segments.count)")
                                    .font(DS.Fonts.caption())
                                    .foregroundColor(DS.Colors.textSecondary)
                            }
                            .padding(DS.Spacing.md)
                            .glassCard(cornerRadius: DS.Radius.sm)
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(.horizontal, DS.Spacing.xl)
                }
                .padding(.top, DS.Spacing.sm)
            }
        }
        .padding(.bottom, DS.Spacing.xl)
    }

    private func statCard(value: String, label: String, icon: String) -> some View {
        VStack(spacing: DS.Spacing.sm) {
            Text(icon)
                .font(.system(size: 24))

            Text(value)
                .font(DS.Fonts.serifBold(24))
                .foregroundColor(DS.Colors.textPrimary)

            Text(label)
                .font(DS.Fonts.caption())
                .foregroundColor(DS.Colors.textSecondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, DS.Spacing.lg)
        .glassCard()
    }

    private var streakSection: some View {
        VStack(alignment: .leading, spacing: DS.Spacing.md) {
            Text("読書の記録")
                .sectionHeader()
                .padding(.horizontal, DS.Spacing.xl)

            StreakCard(streak: store.streak)
                .padding(.horizontal, DS.Spacing.xl)
        }
        .padding(.bottom, DS.Spacing.xl)
    }

    private var achievementsSection: some View {
        VStack(alignment: .leading, spacing: DS.Spacing.md) {
            HStack {
                Text("実績")
                    .sectionHeader()
                Spacer()
                Text("\(store.unlockedAchievementIds.count)/\(AchievementsData.all.count)")
                    .font(DS.Fonts.caption())
                    .foregroundColor(DS.Colors.textSecondary)
            }
            .padding(.horizontal, DS.Spacing.xl)

            ForEach(Achievement.AchievementCategory.allCases, id: \.rawValue) { category in
                categorySection(category)
            }
        }
        .padding(.bottom, DS.Spacing.xl)
    }

    private func categorySection(_ category: Achievement.AchievementCategory) -> some View {
        let badges = AchievementsData.all.filter { $0.category == category }

        return VStack(alignment: .leading, spacing: DS.Spacing.sm) {
            HStack(spacing: DS.Spacing.xs) {
                Circle()
                    .fill(category.color)
                    .frame(width: 8, height: 8)
                Text(category.rawValue)
                    .font(DS.Fonts.body(12, weight: .medium))
                    .foregroundColor(DS.Colors.textSecondary)
            }
            .padding(.horizontal, DS.Spacing.xl)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: DS.Spacing.md) {
                    ForEach(badges) { badge in
                        AchievementBadge(
                            achievement: badge,
                            isUnlocked: store.isAchievementUnlocked(badge.id)
                        )
                    }
                }
                .padding(.horizontal, DS.Spacing.xl)
            }
        }
        .padding(.bottom, DS.Spacing.sm)
    }

    private var premiumSection: some View {
        NavigationLink(destination: PremiumView()) {
            HStack(spacing: DS.Spacing.md) {
                Text("⭐")
                    .font(.system(size: 20))

                VStack(alignment: .leading, spacing: 2) {
                    Text("Premium")
                        .font(DS.Fonts.body(14, weight: .medium))
                        .foregroundColor(DS.Colors.accentWarm)
                    Text("すべての作品と機能をアンロック")
                        .font(DS.Fonts.caption())
                        .foregroundColor(DS.Colors.textSecondary)
                }

                Spacer()

                Text("→")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(DS.Colors.accentWarm.opacity(0.6))
            }
            .padding(DS.Spacing.xl)
            .background(
                RoundedRectangle(cornerRadius: DS.Radius.lg)
                    .fill(DS.Colors.bgCard.opacity(0.6))
                    .overlay(
                        RoundedRectangle(cornerRadius: DS.Radius.lg)
                            .strokeBorder(DS.Colors.accentWarm.opacity(0.15), lineWidth: 1)
                    )
            )
        }
        .buttonStyle(.plain)
        .padding(.horizontal, DS.Spacing.xl)
        .padding(.bottom, DS.Spacing.xxxl)
    }
}

#Preview {
    NavigationStack {
        ProfileView()
    }
}
