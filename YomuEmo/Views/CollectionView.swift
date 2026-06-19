import SwiftUI

struct CollectionView: View {
    @State private var store = StoreManager.shared
    @State private var selectedTab = 0
    @State private var showDailyQuote = false

    private let tabs = ["集めた言葉", "読書の記録", "バッジ"]

    var body: some View {
        ZStack {
            DS.Colors.bgPrimary.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {
                    headerSection
                    dailyQuoteCard
                    segmentPicker
                    switch selectedTab {
                    case 0: quotesSection
                    case 1: readingHistorySection
                    default: badgesSection
                    }
                }
            }
        }
        .navigationBarHidden(true)
    }

    // MARK: - Header

    private var headerSection: some View {
        VStack(alignment: .leading, spacing: DS.Spacing.xs) {
            Text("ことば帳")
                .font(DS.Fonts.serifBold(24))
                .foregroundColor(DS.Colors.textPrimary)

            Text("心に残った言葉たち")
                .font(DS.Fonts.body(14))
                .foregroundColor(DS.Colors.textSecondary)
        }
        .padding(.horizontal, DS.Spacing.xl)
        .padding(.top, DS.Spacing.lg)
        .padding(.bottom, DS.Spacing.xl)
    }

    // MARK: - Daily Quote

    private var dailyQuoteCard: some View {
        Group {
            if let quote = store.randomQuote() {
                Button(action: { withAnimation { showDailyQuote.toggle() } }) {
                    VStack(alignment: .leading, spacing: DS.Spacing.md) {
                        HStack(spacing: DS.Spacing.sm) {
                            Text("📖")
                                .font(.system(size: 16))
                            Text("今日の一文")
                                .font(DS.Fonts.caption())
                                .foregroundColor(DS.Colors.accentWarm)
                                .textCase(.uppercase)
                                .tracking(1)
                            Spacer()
                            Image(systemName: showDailyQuote ? "chevron.up" : "chevron.down")
                                .font(.system(size: 12))
                                .foregroundColor(DS.Colors.textSecondary)
                        }

                        if showDailyQuote {
                            Text("「\(quote.text)」")
                                .font(DS.Fonts.serif(15))
                                .foregroundColor(DS.Colors.textPrimary)
                                .lineSpacing(6)
                                .transition(.opacity.combined(with: .move(edge: .top)))

                            Text("── \(quote.workTitle)　\(quote.authorName)")
                                .font(DS.Fonts.body(12))
                                .foregroundColor(DS.Colors.textSecondary)
                                .transition(.opacity)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
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
                .padding(.bottom, DS.Spacing.xl)
                .onAppear { showDailyQuote = true }
            }
        }
    }

    // MARK: - Segment Picker

    private var segmentPicker: some View {
        HStack(spacing: 0) {
            ForEach(Array(tabs.enumerated()), id: \.offset) { index, tab in
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.2)) { selectedTab = index }
                }) {
                    Text(tab)
                        .font(DS.Fonts.small())
                        .fontWeight(.medium)
                        .foregroundColor(selectedTab == index ? .white : DS.Colors.textSecondary)
                        .padding(.horizontal, DS.Spacing.lg)
                        .padding(.vertical, DS.Spacing.sm)
                        .background(
                            Capsule()
                                .fill(selectedTab == index ? DS.Colors.accentIndigo : Color.clear)
                        )
                }
            }
        }
        .padding(3)
        .background(
            Capsule()
                .fill(DS.Colors.bgCard.opacity(0.8))
                .overlay(Capsule().strokeBorder(DS.Colors.borderSubtle, lineWidth: 1))
        )
        .padding(.horizontal, DS.Spacing.xl)
        .padding(.bottom, DS.Spacing.xl)
    }

    // MARK: - Quotes Tab

    private var quotesSection: some View {
        VStack(alignment: .leading, spacing: DS.Spacing.md) {
            if store.savedQuotes.isEmpty {
                quotesEmptyState
            } else {
                HStack {
                    Text("\(store.savedQuotes.count)件の言葉")
                        .font(DS.Fonts.caption())
                        .foregroundColor(DS.Colors.textSecondary)
                    Spacer()
                }
                .padding(.horizontal, DS.Spacing.xl)

                LazyVStack(spacing: DS.Spacing.lg) {
                    ForEach(store.savedQuotes) { quote in
                        QuoteCard(quote: quote) {
                            withAnimation {
                                store.removeQuote(quote)
                            }
                        }
                    }
                }
                .padding(.horizontal, DS.Spacing.xl)
            }
        }
        .padding(.bottom, DS.Spacing.xxxl)
    }

    private var quotesEmptyState: some View {
        VStack(spacing: DS.Spacing.lg) {
            Text("📝")
                .font(.system(size: 48))
            Text("まだ保存した言葉がありません")
                .font(DS.Fonts.body(14, weight: .medium))
                .foregroundColor(DS.Colors.textPrimary)
            Text("読書中にブックマークボタンで\n心に残った一文を保存できます")
                .font(DS.Fonts.body(12))
                .foregroundColor(DS.Colors.textSecondary)
                .multilineTextAlignment(.center)
                .lineSpacing(3)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 60)
    }

    // MARK: - Reading History Tab

    private var readingHistorySection: some View {
        VStack(alignment: .leading, spacing: DS.Spacing.md) {
            readingFootprints

            if !store.currentlyReading.isEmpty {
                currentlyReadingSection
            }

            completedWorksSection
        }
        .padding(.bottom, DS.Spacing.xxxl)
    }

    private var readingFootprints: some View {
        VStack(spacing: DS.Spacing.md) {
            HStack(spacing: DS.Spacing.md) {
                footprintStat(value: "\(store.completedWorkCount)", label: "読破作品", icon: "📚")
                footprintStat(value: "\(store.completedAuthorCount)", label: "読んだ作者", icon: "🖋️")
            }
            HStack(spacing: DS.Spacing.md) {
                footprintStat(value: "\(store.savedQuotes.count)", label: "保存した言葉", icon: "💬")
                footprintStat(value: "\(store.streak.currentStreak)", label: "連続読書日数", icon: "🔥")
            }
        }
        .padding(.horizontal, DS.Spacing.xl)
    }

    private func footprintStat(value: String, label: String, icon: String) -> some View {
        HStack(spacing: DS.Spacing.md) {
            Text(icon)
                .font(.system(size: 20))

            VStack(alignment: .leading, spacing: 2) {
                Text(value)
                    .font(DS.Fonts.serifBold(20))
                    .foregroundColor(DS.Colors.textPrimary)
                Text(label)
                    .font(DS.Fonts.caption())
                    .foregroundColor(DS.Colors.textSecondary)
            }

            Spacer()
        }
        .padding(DS.Spacing.lg)
        .frame(maxWidth: .infinity, alignment: .leading)
        .glassCard()
    }

    private var currentlyReadingSection: some View {
        VStack(alignment: .leading, spacing: DS.Spacing.md) {
            Text("読書中")
                .sectionHeader()
                .padding(.horizontal, DS.Spacing.xl)

            LazyVStack(spacing: DS.Spacing.sm) {
                ForEach(store.currentlyReading) { work in
                    NavigationLink(destination: ReadingView(work: work)) {
                        HStack(spacing: DS.Spacing.md) {
                            Text(work.coverEmoji)
                                .font(.system(size: 28))

                            VStack(alignment: .leading, spacing: 2) {
                                Text(work.title)
                                    .font(DS.Fonts.body(14, weight: .medium))
                                    .foregroundColor(DS.Colors.textPrimary)
                                Text(work.authorName)
                                    .font(DS.Fonts.caption())
                                    .foregroundColor(DS.Colors.textSecondary)
                            }

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
            }
            .padding(.horizontal, DS.Spacing.xl)
        }
        .padding(.top, DS.Spacing.md)
    }

    private var completedWorksSection: some View {
        VStack(alignment: .leading, spacing: DS.Spacing.md) {
            Text("読了した作品")
                .sectionHeader()
                .padding(.horizontal, DS.Spacing.xl)

            let completed = WorksData.all.filter { store.getProgress(for: $0.id).completed }

            if completed.isEmpty {
                Text("まだ読了した作品はありません")
                    .font(DS.Fonts.body(13))
                    .foregroundColor(DS.Colors.textSecondary)
                    .padding(.horizontal, DS.Spacing.xl)
            } else {
                LazyVStack(spacing: DS.Spacing.sm) {
                    ForEach(completed) { work in
                        HStack(spacing: DS.Spacing.md) {
                            Text(work.coverEmoji)
                                .font(.system(size: 28))

                            VStack(alignment: .leading, spacing: 2) {
                                Text(work.title)
                                    .font(DS.Fonts.body(14, weight: .medium))
                                    .foregroundColor(DS.Colors.textPrimary)
                                Text(work.authorName)
                                    .font(DS.Fonts.caption())
                                    .foregroundColor(DS.Colors.textSecondary)
                            }

                            Spacer()

                            Text("読了")
                                .font(DS.Fonts.caption())
                                .foregroundColor(DS.Colors.accentIndigo)
                        }
                        .padding(DS.Spacing.md)
                        .glassCard(cornerRadius: DS.Radius.sm)
                    }
                }
                .padding(.horizontal, DS.Spacing.xl)
            }
        }
        .padding(.top, DS.Spacing.md)
    }

    // MARK: - Badges Tab

    private var badgesSection: some View {
        VStack(alignment: .leading, spacing: DS.Spacing.md) {
            HStack {
                Spacer()
                Text("\(store.unlockedAchievementIds.count)/\(AchievementsData.all.count)")
                    .font(DS.Fonts.caption())
                    .foregroundColor(DS.Colors.textSecondary)
            }
            .padding(.horizontal, DS.Spacing.xl)

            ForEach(Achievement.AchievementCategory.allCases, id: \.rawValue) { category in
                badgeCategorySection(category)
            }
        }
        .padding(.bottom, DS.Spacing.xxxl)
    }

    private func badgeCategorySection(_ category: Achievement.AchievementCategory) -> some View {
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
}

#Preview {
    NavigationStack {
        CollectionView()
    }
}
