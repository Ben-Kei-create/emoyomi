import SwiftUI

struct HomeView: View {
    @State private var selectedTag: EmotionTag?

    private var filteredWorks: [Work] {
        if let tag = selectedTag {
            return WorksData.works(withTag: tag)
        }
        return WorksData.all
    }

    private let displayTags: [EmotionTag] = [
        .孤独, .不安, .嫉妬, .希望, .怒り, .恋愛,
        .罪悪感, .生きづらさ, .青春, .絶望, .自己嫌悪, .承認欲求
    ]

    @State private var store = StoreManager.shared

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 0) {
                headerSection
                streakBanner
                diagnosisCard
                emotionTagsSection
                worksSection
                authorsSection
            }
        }
        .background(DS.Colors.bgPrimary)
        .navigationBarHidden(true)
    }

    private var headerSection: some View {
        HStack {
            VStack(alignment: .leading, spacing: DS.Spacing.xs) {
                Text("よむエモ")
                    .font(DS.Fonts.serifBold(24))
                    .foregroundStyle(DS.Gradients.brandTitle)
                Text("今日はどんな気分？")
                    .font(DS.Fonts.body(14))
                    .foregroundColor(DS.Colors.textSecondary)
            }
            Spacer()
        }
        .padding(.horizontal, DS.Spacing.xl)
        .padding(.top, DS.Spacing.lg)
        .padding(.bottom, DS.Spacing.xl)
    }

    private var streakBanner: some View {
        Group {
            let streak = store.streak
            if streak.streakAlive && streak.currentStreak > 0 {
                HStack(spacing: DS.Spacing.md) {
                    Text(streak.currentStreak >= 3 ? "🔥" : "📖")
                        .font(.system(size: 20))

                    VStack(alignment: .leading, spacing: 2) {
                        Text("\(streak.currentStreak)日連続読書中！")
                            .font(DS.Fonts.body(14, weight: .medium))
                            .foregroundColor(DS.Colors.textPrimary)
                        Text("今日も読んでストリークを伸ばそう")
                            .font(DS.Fonts.caption())
                            .foregroundColor(DS.Colors.textSecondary)
                    }

                    Spacer()
                }
                .padding(DS.Spacing.lg)
                .glassCardHighlight(streak.currentStreak >= 7 ? DS.Colors.accentWarm : DS.Colors.accentIndigo)
                .padding(.horizontal, DS.Spacing.xl)
                .padding(.bottom, DS.Spacing.xl)
            }
        }
    }

    private var diagnosisCard: some View {
        NavigationLink(destination: EmotionDiagnosisView()) {
            HStack(spacing: DS.Spacing.lg) {
                VStack(alignment: .leading, spacing: DS.Spacing.sm) {
                    Text("✨ 今日の気分から選ぶ")
                        .font(DS.Fonts.body(16, weight: .medium))
                        .foregroundColor(DS.Colors.textPaper)

                    Text("3つの質問で、あなたにぴったりの\n文学作品を見つけます")
                        .font(DS.Fonts.body(12))
                        .foregroundColor(DS.Colors.textPaper.opacity(0.7))
                        .lineSpacing(2)
                }

                Spacer()

                Text("→")
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(DS.Colors.textPaper.opacity(0.6))
            }
            .padding(DS.Spacing.xl)
            .background(
                RoundedRectangle(cornerRadius: DS.Radius.lg)
                    .fill(DS.Gradients.diagnosisCard)
                    .shadow(color: DS.Colors.softPink.opacity(0.3), radius: 8, y: 2)
            )
        }
        .buttonStyle(.plain)
        .padding(.horizontal, DS.Spacing.xl)
        .padding(.bottom, DS.Spacing.xxl)
    }

    private var emotionTagsSection: some View {
        VStack(alignment: .leading, spacing: DS.Spacing.md) {
            Text("感情から選ぶ")
                .sectionHeader()
                .padding(.horizontal, DS.Spacing.xl)

            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: DS.Spacing.sm) {
                    ForEach(displayTags) { tag in
                        EmotionTagButton(
                            tag: tag,
                            isSelected: selectedTag == tag,
                            action: {
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    selectedTag = selectedTag == tag ? nil : tag
                                }
                            }
                        )
                    }
                }
                .padding(.horizontal, DS.Spacing.xl)
            }
        }
        .padding(.bottom, 28)
    }

    private var worksSection: some View {
        VStack(alignment: .leading, spacing: DS.Spacing.md) {
            Text(selectedTag != nil ? "「\(selectedTag!.rawValue)」の作品" : "すべての作品")
                .sectionHeader()
                .padding(.horizontal, DS.Spacing.xl)

            LazyVStack(spacing: DS.Spacing.md) {
                ForEach(Array(filteredWorks.enumerated()), id: \.element.id) { _, work in
                    NavigationLink(destination: ReadingView(work: work)) {
                        WorkCard(work: work)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, DS.Spacing.xl)
        }
        .padding(.bottom, 28)
    }

    private var authorsSection: some View {
        VStack(alignment: .leading, spacing: DS.Spacing.md) {
            Text("文豪たち")
                .sectionHeader()
                .padding(.horizontal, DS.Spacing.xl)

            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: DS.Spacing.md) {
                    ForEach(AuthorsData.all) { author in
                        NavigationLink(destination: AuthorProfileView(author: author)) {
                            authorCard(author)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, DS.Spacing.xl)
            }
        }
        .padding(.bottom, DS.Spacing.xxxl)
    }

    private func authorCard(_ author: Author) -> some View {
        VStack(alignment: .leading, spacing: DS.Spacing.sm) {
            Text(author.icon)
                .font(.system(size: 28))

            Text(author.name)
                .font(DS.Fonts.body(14, weight: .medium))
                .foregroundColor(DS.Colors.textPrimary)

            Text(author.bio)
                .font(DS.Fonts.caption())
                .foregroundColor(DS.Colors.textSecondary)
                .lineLimit(2)
        }
        .frame(width: 150, alignment: .leading)
        .padding(DS.Spacing.lg)
        .glassCard()
    }
}

#Preview {
    NavigationStack {
        HomeView()
    }
}
