import SwiftUI

struct CompletionView: View {
    let work: Work
    @Environment(\.dismiss) private var dismiss
    @State private var showContent = false
    @State private var quoteSaved = false
    @State private var store = StoreManager.shared

    private var aggregateEmotions: [EmotionTag: Int] {
        var totals: [EmotionTag: Int] = [:]
        var counts: [EmotionTag: Int] = [:]
        for segment in work.segments {
            for (tag, score) in segment.emotionScores {
                totals[tag, default: 0] += score
                counts[tag, default: 0] += 1
            }
        }
        var result: [EmotionTag: Int] = [:]
        for (tag, total) in totals {
            result[tag] = total / (counts[tag] ?? 1)
        }
        return result
    }

    var body: some View {
        ZStack {
            DS.Colors.bgPrimary.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    Spacer().frame(height: 80)

                    Text(work.coverEmoji)
                        .font(.system(size: 64))
                        .padding(.bottom, DS.Spacing.xl)
                        .opacity(showContent ? 1 : 0)
                        .scaleEffect(showContent ? 1 : 0.5)

                    Text("読了")
                        .font(DS.Fonts.serifBold(28))
                        .foregroundColor(DS.Colors.textPrimary)
                        .padding(.bottom, DS.Spacing.sm)
                        .opacity(showContent ? 1 : 0)
                        .offset(y: showContent ? 0 : 16)

                    Text("\(work.title) ── \(work.authorName)")
                        .font(DS.Fonts.body(14))
                        .foregroundColor(DS.Colors.textSecondary)
                        .padding(.bottom, DS.Spacing.xxxl)
                        .opacity(showContent ? 1 : 0)
                        .offset(y: showContent ? 0 : 16)

                    VStack(spacing: DS.Spacing.md) {
                        xpSummaryCard
                        emotionSummaryCard
                        themeCard
                        modernConnectionCard
                        emotionTagsCard

                        if let poll = work.polls.first {
                            PollCard(poll: poll)
                                .padding(.horizontal, DS.Spacing.xl)
                        }

                        saveQuoteCard
                    }
                    .opacity(showContent ? 1 : 0)
                    .offset(y: showContent ? 0 : 24)

                    HStack(spacing: DS.Spacing.md) {
                        NavigationLink(destination: AuthorProfileView(
                            author: AuthorsData.find(by: work.authorId)!
                        )) {
                            Text("文豪を見る")
                                .font(DS.Fonts.body(14))
                                .foregroundColor(DS.Colors.textSecondary)
                                .frame(maxWidth: .infinity)
                                .frame(height: 48)
                                .background(
                                    Capsule()
                                        .fill(DS.Colors.bgCard.opacity(0.6))
                                        .overlay(
                                            Capsule()
                                                .strokeBorder(DS.Colors.borderSubtle, lineWidth: 1)
                                        )
                                )
                        }

                        Button(action: { dismiss() }) {
                            Text("ホームに戻る")
                                .font(DS.Fonts.body(14, weight: .medium))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 48)
                                .background(
                                    Capsule().fill(DS.Colors.accentIndigo)
                                )
                        }
                    }
                    .padding(.horizontal, DS.Spacing.xl)
                    .padding(.top, DS.Spacing.xxxl)
                    .padding(.bottom, 40)
                }
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            withAnimation(.easeOut(duration: 0.8)) {
                showContent = true
            }
        }
    }

    private var xpSummaryCard: some View {
        VStack(spacing: DS.Spacing.md) {
            HStack(spacing: DS.Spacing.sm) {
                Text("📖")
                    .font(.system(size: 16))
                Text("読書の経験値")
                    .font(DS.Fonts.caption())
                    .foregroundColor(DS.Colors.accentNeon)
                    .textCase(.uppercase)
                    .tracking(1)
            }

            Text("+100 XP")
                .font(DS.Fonts.serifBold(24))
                .foregroundStyle(DS.Gradients.xpBar)

            XPBar(xp: store.totalXP)
                .padding(.top, DS.Spacing.xs)
        }
        .frame(maxWidth: .infinity)
        .padding(DS.Spacing.xl)
        .glassCard()
        .padding(.horizontal, DS.Spacing.xl)
    }

    private var emotionSummaryCard: some View {
        VStack(alignment: .leading, spacing: DS.Spacing.md) {
            HStack(spacing: DS.Spacing.sm) {
                Text("📊")
                    .font(.system(size: 16))
                Text("あなたが読んだ感情")
                    .font(DS.Fonts.caption())
                    .foregroundColor(DS.Colors.accentNeon)
                    .textCase(.uppercase)
                    .tracking(1)
            }

            EmotionMeter(emotionScores: aggregateEmotions)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(DS.Spacing.xl)
        .glassCard()
        .padding(.horizontal, DS.Spacing.xl)
    }

    private var themeCard: some View {
        VStack(alignment: .leading, spacing: DS.Spacing.sm) {
            HStack(spacing: DS.Spacing.sm) {
                Text("🔑")
                    .font(.system(size: 16))
                Text("テーマ")
                    .font(DS.Fonts.caption())
                    .foregroundColor(DS.Colors.accentNeon)
                    .textCase(.uppercase)
                    .tracking(1)
            }

            Text("「\(work.afterword.theme)」")
                .font(DS.Fonts.body(15, weight: .medium))
                .foregroundColor(DS.Colors.textPrimary)
                .lineSpacing(4)

            Text(work.afterword.point)
                .font(DS.Fonts.body(13))
                .foregroundColor(DS.Colors.textSecondary)
                .lineSpacing(4)
                .padding(.top, DS.Spacing.xs)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(DS.Spacing.xl)
        .glassCard()
        .padding(.horizontal, DS.Spacing.xl)
    }

    private var modernConnectionCard: some View {
        VStack(alignment: .leading, spacing: DS.Spacing.sm) {
            HStack(spacing: DS.Spacing.sm) {
                Text("🔗")
                    .font(.system(size: 16))
                Text("現代とのつながり")
                    .font(DS.Fonts.caption())
                    .foregroundColor(DS.Colors.accentPink)
                    .textCase(.uppercase)
                    .tracking(1)
            }

            Text("「\(work.afterword.modern)」")
                .font(DS.Fonts.body(14))
                .foregroundColor(DS.Colors.textPrimary)
                .lineSpacing(4)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(DS.Spacing.xl)
        .glassCard()
        .padding(.horizontal, DS.Spacing.xl)
    }

    private var emotionTagsCard: some View {
        VStack(alignment: .leading, spacing: DS.Spacing.sm) {
            Text("この作品の感情")
                .font(DS.Fonts.caption())
                .foregroundColor(DS.Colors.textSecondary)
                .textCase(.uppercase)
                .tracking(1)

            FlowLayout(spacing: DS.Spacing.sm) {
                ForEach(work.tags) { tag in
                    HStack(spacing: DS.Spacing.xs) {
                        Text(tag.emoji)
                            .font(DS.Fonts.small())
                        Text(tag.rawValue)
                            .font(DS.Fonts.small())
                    }
                    .foregroundColor(DS.Colors.textSecondary)
                    .padding(.horizontal, DS.Spacing.md)
                    .padding(.vertical, 6)
                    .background(
                        Capsule().fill(Color.white.opacity(0.05))
                    )
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(DS.Spacing.lg)
        .glassCard()
        .padding(.horizontal, DS.Spacing.xl)
    }

    private var saveQuoteCard: some View {
        Button(action: {
            let bestSegment = work.segments.max(by: {
                ($0.emotionScores.values.max() ?? 0) < ($1.emotionScores.values.max() ?? 0)
            })
            if let segment = bestSegment {
                let quote = FavoriteQuote(
                    text: segment.originalText,
                    workTitle: work.title,
                    authorName: work.authorName
                )
                StoreManager.shared.saveQuote(quote)
                withAnimation { quoteSaved = true }
            }
        }) {
            HStack(spacing: DS.Spacing.md) {
                Image(systemName: quoteSaved ? "bookmark.fill" : "bookmark")
                    .font(.system(size: 20))
                    .foregroundColor(quoteSaved ? DS.Colors.popYellow : DS.Colors.textSecondary)

                VStack(alignment: .leading, spacing: 2) {
                    Text(quoteSaved ? "保存しました！" : "印象に残った一文を保存")
                        .font(DS.Fonts.body(14, weight: .medium))
                        .foregroundColor(DS.Colors.textPrimary)
                    if !quoteSaved {
                        Text("お気に入りタブで確認できます")
                            .font(DS.Fonts.body(11))
                            .foregroundColor(DS.Colors.textSecondary)
                    }
                }

                Spacer()
            }
            .padding(DS.Spacing.xl)
            .glassCard()
        }
        .buttonStyle(.plain)
        .padding(.horizontal, DS.Spacing.xl)
        .disabled(quoteSaved)
    }
}

struct FlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = arrangeSubviews(proposal: proposal, subviews: subviews)
        return result.size
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = arrangeSubviews(proposal: proposal, subviews: subviews)
        for (index, position) in result.positions.enumerated() {
            subviews[index].place(
                at: CGPoint(x: bounds.minX + position.x, y: bounds.minY + position.y),
                proposal: .unspecified
            )
        }
    }

    private func arrangeSubviews(proposal: ProposedViewSize, subviews: Subviews) -> (positions: [CGPoint], size: CGSize) {
        let maxWidth = proposal.width ?? .infinity
        var positions: [CGPoint] = []
        var x: CGFloat = 0
        var y: CGFloat = 0
        var rowHeight: CGFloat = 0
        var maxX: CGFloat = 0

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if x + size.width > maxWidth && x > 0 {
                x = 0
                y += rowHeight + spacing
                rowHeight = 0
            }
            positions.append(CGPoint(x: x, y: y))
            rowHeight = max(rowHeight, size.height)
            x += size.width + spacing
            maxX = max(maxX, x - spacing)
        }

        return (positions, CGSize(width: maxX, height: y + rowHeight))
    }
}

#Preview {
    NavigationStack {
        CompletionView(work: WorksData.all[0])
    }
}
