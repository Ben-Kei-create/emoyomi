import SwiftUI

struct WorksListView: View {
    @State private var selectedTag: EmotionTag?
    @Environment(\.dismiss) private var dismiss

    private var filteredWorks: [Work] {
        if let tag = selectedTag {
            return WorksData.works(withTag: tag)
        }
        return WorksData.all
    }

    private let allTags: [EmotionTag] = [
        .孤独, .不安, .嫉妬, .希望, .怒り, .恋愛,
        .罪悪感, .生きづらさ, .青春, .絶望, .自己嫌悪, .承認欲求
    ]

    var body: some View {
        ZStack {
            DS.Colors.bgPrimary.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {
                    headerSection
                    filterSection
                    worksSection
                }
            }
        }
        .navigationBarHidden(true)
    }

    private var headerSection: some View {
        VStack(alignment: .leading, spacing: DS.Spacing.sm) {
            Button(action: { dismiss() }) {
                Text("← 戻る")
                    .font(DS.Fonts.body(14))
                    .foregroundColor(DS.Colors.textSecondary)
            }

            Text("作品一覧")
                .font(DS.Fonts.serifBold(24))
                .foregroundColor(DS.Colors.textPrimary)
        }
        .padding(.horizontal, DS.Spacing.xl)
        .padding(.top, DS.Spacing.md)
        .padding(.bottom, DS.Spacing.xl)
    }

    private var filterSection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: DS.Spacing.sm) {
                Button(action: {
                    withAnimation { selectedTag = nil }
                }) {
                    Text("すべて")
                        .font(DS.Fonts.small())
                        .foregroundColor(selectedTag == nil ? .white : DS.Colors.textSecondary)
                        .padding(.horizontal, DS.Spacing.md)
                        .padding(.vertical, DS.Spacing.sm)
                        .background(
                            Capsule().fill(
                                selectedTag == nil
                                    ? DS.Colors.accentIndigo
                                    : DS.Colors.bgCard.opacity(0.6)
                            )
                        )
                        .overlay(
                            Capsule().strokeBorder(
                                selectedTag == nil ? Color.clear : DS.Colors.borderSubtle,
                                lineWidth: 1
                            )
                        )
                }

                ForEach(allTags) { tag in
                    EmotionTagButton(
                        tag: tag,
                        isSelected: selectedTag == tag,
                        action: {
                            withAnimation { selectedTag = tag }
                        }
                    )
                }
            }
            .padding(.horizontal, DS.Spacing.xl)
        }
        .padding(.bottom, DS.Spacing.xl)
    }

    private var worksSection: some View {
        VStack(alignment: .leading, spacing: DS.Spacing.md) {
            Text("\(filteredWorks.count)作品")
                .font(DS.Fonts.small())
                .foregroundColor(DS.Colors.textSecondary)
                .padding(.horizontal, DS.Spacing.xl)

            LazyVStack(spacing: DS.Spacing.md) {
                ForEach(filteredWorks) { work in
                    NavigationLink(destination: ReadingView(work: work)) {
                        WorkCard(work: work)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, DS.Spacing.xl)
        }
        .padding(.bottom, DS.Spacing.xxxl)
    }
}

#Preview {
    NavigationStack {
        WorksListView()
    }
}
