import SwiftUI

struct CollectionView: View {
    @State private var store = StoreManager.shared
    @State private var selectedTab = 0

    private var collection: [EmotionCollectionEntry] {
        store.emotionCollection
    }

    private var quotes: [FavoriteQuote] {
        store.savedQuotes
    }

    var body: some View {
        ZStack {
            DS.Colors.bgPrimary.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {
                    headerSection
                    collectionSummary
                    segmentPicker
                    if selectedTab == 0 {
                        emotionBookSection
                    } else {
                        quotesSection
                    }
                }
            }
        }
        .navigationBarHidden(true)
    }

    private var headerSection: some View {
        VStack(alignment: .leading, spacing: DS.Spacing.xs) {
            Text("コレクション")
                .font(DS.Fonts.serifBold(24))
                .foregroundColor(DS.Colors.textPrimary)

            Text("集めた感情と名言")
                .font(DS.Fonts.body(14))
                .foregroundColor(DS.Colors.textSecondary)
        }
        .padding(.horizontal, DS.Spacing.xl)
        .padding(.top, DS.Spacing.lg)
        .padding(.bottom, DS.Spacing.xl)
    }

    private var collectionSummary: some View {
        HStack(spacing: 0) {
            summaryItem(
                value: "\(collection.count)/\(EmotionTag.allCases.count)",
                label: "感情発見",
                color: DS.Colors.accentPink
            )
            summaryItem(
                value: "\(quotes.count)",
                label: "名言保存",
                color: DS.Colors.accentWarm
            )
            summaryItem(
                value: "\(collection.filter { $0.masteryLevel == .mastered }.count)",
                label: "共鳴",
                color: DS.Colors.accentLavender
            )
        }
        .padding(DS.Spacing.lg)
        .glassCard()
        .padding(.horizontal, DS.Spacing.xl)
        .padding(.bottom, DS.Spacing.xl)
    }

    private func summaryItem(value: String, label: String, color: Color) -> some View {
        VStack(spacing: DS.Spacing.xs) {
            Text(value)
                .font(DS.Fonts.body(20, weight: .bold))
                .foregroundColor(color)
            Text(label)
                .font(DS.Fonts.caption())
                .foregroundColor(DS.Colors.textSecondary)
        }
        .frame(maxWidth: .infinity)
    }

    private var segmentPicker: some View {
        HStack(spacing: 0) {
            ForEach(["感情図鑑", "名言集"], id: \.self) { tab in
                let index = tab == "感情図鑑" ? 0 : 1
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.2)) { selectedTab = index }
                }) {
                    Text(tab)
                        .font(DS.Fonts.small())
                        .fontWeight(.medium)
                        .foregroundColor(selectedTab == index ? .white : DS.Colors.textSecondary)
                        .padding(.horizontal, DS.Spacing.xl)
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

    // MARK: - Emotion Book

    private var emotionBookSection: some View {
        VStack(alignment: .leading, spacing: DS.Spacing.md) {
            masteryLegend

            let columns = [
                GridItem(.flexible(), spacing: DS.Spacing.md),
                GridItem(.flexible(), spacing: DS.Spacing.md),
                GridItem(.flexible(), spacing: DS.Spacing.md),
            ]

            LazyVGrid(columns: columns, spacing: DS.Spacing.md) {
                ForEach(EmotionTag.allCases) { tag in
                    let entry = collection.first(where: { $0.emotionRawValue == tag.rawValue })
                    EmotionCollectionCard(tag: tag, entry: entry)
                }
            }
            .padding(.horizontal, DS.Spacing.xl)

            if !collection.isEmpty {
                recentDiscoveries
            }
        }
        .padding(.bottom, DS.Spacing.xxxl)
    }

    private var masteryLegend: some View {
        HStack(spacing: DS.Spacing.lg) {
            ForEach([EmotionMastery.undiscovered, .encountered, .familiar, .mastered], id: \.rawValue) { mastery in
                HStack(spacing: DS.Spacing.xs) {
                    Circle()
                        .fill(Color.white.opacity(mastery.opacity * 0.5))
                        .frame(width: 8, height: 8)
                    Text(mastery.rawValue)
                        .font(DS.Fonts.caption())
                        .foregroundColor(DS.Colors.textSecondary)
                }
            }
        }
        .padding(.horizontal, DS.Spacing.xl)
    }

    private var recentDiscoveries: some View {
        VStack(alignment: .leading, spacing: DS.Spacing.md) {
            Text("最近の発見")
                .sectionHeader()
                .padding(.horizontal, DS.Spacing.xl)

            LazyVStack(spacing: DS.Spacing.sm) {
                ForEach(collection.sorted(by: { $0.firstEncountered > $1.firstEncountered }).prefix(5)) { entry in
                    if let tag = entry.tag {
                        HStack(spacing: DS.Spacing.md) {
                            Text(tag.emoji)
                                .font(.system(size: 20))

                            VStack(alignment: .leading, spacing: 2) {
                                Text(tag.rawValue)
                                    .font(DS.Fonts.body(14, weight: .medium))
                                    .foregroundColor(DS.Colors.textPrimary)

                                Text("最大強度: \(entry.maxIntensity)  |  \(entry.encounters)回出会い")
                                    .font(DS.Fonts.caption())
                                    .foregroundColor(DS.Colors.textSecondary)
                            }

                            Spacer()

                            Text(entry.masteryLevel.rawValue)
                                .font(DS.Fonts.caption())
                                .foregroundColor(tag.color)
                                .padding(.horizontal, DS.Spacing.sm)
                                .padding(.vertical, DS.Spacing.xs)
                                .background(
                                    Capsule().fill(tag.color.opacity(0.15))
                                )
                        }
                        .padding(DS.Spacing.md)
                        .glassCard(cornerRadius: DS.Radius.sm)
                    }
                }
            }
            .padding(.horizontal, DS.Spacing.xl)
        }
        .padding(.top, DS.Spacing.xl)
    }

    // MARK: - Quotes

    private var quotesSection: some View {
        VStack(alignment: .leading, spacing: DS.Spacing.md) {
            if quotes.isEmpty {
                quotesEmptyState
            } else {
                LazyVStack(spacing: DS.Spacing.lg) {
                    ForEach(quotes) { quote in
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
        VStack(spacing: DS.Spacing.xl) {
            Text("📝")
                .font(.system(size: 48))
            Text("まだ保存した名言がありません")
                .font(DS.Fonts.body(14, weight: .medium))
                .foregroundColor(DS.Colors.textPrimary)
            Text("読書中に気になった一文を\n保存してみましょう")
                .font(DS.Fonts.body(12))
                .foregroundColor(DS.Colors.textSecondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 60)
    }
}

#Preview {
    NavigationStack {
        CollectionView()
    }
}
