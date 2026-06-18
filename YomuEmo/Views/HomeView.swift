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

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 0) {
                headerSection
                emotionTagsSection
                worksSection
                authorsSection
            }
        }
        .background(Color(hex: "0a0e1a"))
        .navigationBarHidden(true)
    }

    private var headerSection: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("よむエモ")
                    .font(.custom("HiraginoSans-W7", size: 24))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [Color(hex: "818cf8"), Color(hex: "ec4899")],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                Text("今日はどんな気分？")
                    .font(.system(size: 14))
                    .foregroundColor(Color(hex: "9ca3af"))
            }
            Spacer()
            NavigationLink(destination: PremiumView()) {
                Text("Premium")
                    .font(.system(size: 12))
                    .foregroundColor(Color(hex: "f59e0b"))
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .overlay(
                        Capsule()
                            .strokeBorder(Color(hex: "f59e0b").opacity(0.3), lineWidth: 1)
                    )
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 16)
        .padding(.bottom, 20)
    }

    private var emotionTagsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("感情から選ぶ")
                .font(.system(size: 11, weight: .medium))
                .foregroundColor(Color(hex: "9ca3af"))
                .textCase(.uppercase)
                .tracking(1)
                .padding(.horizontal, 20)

            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 8) {
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
                .padding(.horizontal, 20)
            }
        }
        .padding(.bottom, 28)
    }

    private var worksSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(selectedTag != nil ? "「\(selectedTag!.rawValue)」の作品" : "すべての作品")
                .font(.system(size: 11, weight: .medium))
                .foregroundColor(Color(hex: "9ca3af"))
                .textCase(.uppercase)
                .tracking(1)
                .padding(.horizontal, 20)

            LazyVStack(spacing: 12) {
                ForEach(Array(filteredWorks.enumerated()), id: \.element.id) { index, work in
                    NavigationLink(destination: ReadingView(work: work)) {
                        WorkCardView(work: work)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 20)
        }
        .padding(.bottom, 28)
    }

    private var authorsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("文豪たち")
                .font(.system(size: 11, weight: .medium))
                .foregroundColor(Color(hex: "9ca3af"))
                .textCase(.uppercase)
                .tracking(1)
                .padding(.horizontal, 20)

            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 12) {
                    ForEach(AuthorsData.all) { author in
                        NavigationLink(destination: AuthorProfileView(author: author)) {
                            authorCard(author)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 20)
            }
        }
        .padding(.bottom, 32)
    }

    private func authorCard(_ author: Author) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(author.icon)
                .font(.system(size: 28))

            Text(author.name)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(Color(hex: "e8e2d6"))

            Text(author.bio)
                .font(.system(size: 10))
                .foregroundColor(Color(hex: "9ca3af"))
                .lineLimit(2)
        }
        .frame(width: 150, alignment: .leading)
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(hex: "1a1f35").opacity(0.6))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .strokeBorder(Color.white.opacity(0.08), lineWidth: 1)
                )
        )
    }
}

#Preview {
    NavigationStack {
        HomeView()
    }
}
