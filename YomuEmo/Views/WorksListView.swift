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
            Color(hex: "0a0e1a").ignoresSafeArea()

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
        VStack(alignment: .leading, spacing: 8) {
            Button(action: { dismiss() }) {
                Text("← 戻る")
                    .font(.system(size: 14))
                    .foregroundColor(Color(hex: "9ca3af"))
            }

            Text("作品一覧")
                .font(.custom("HiraginoSans-W7", size: 24))
                .foregroundColor(Color(hex: "e8e2d6"))
        }
        .padding(.horizontal, 20)
        .padding(.top, 12)
        .padding(.bottom, 20)
    }

    private var filterSection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                Button(action: {
                    withAnimation { selectedTag = nil }
                }) {
                    Text("すべて")
                        .font(.system(size: 12))
                        .foregroundColor(selectedTag == nil ? .white : Color(hex: "9ca3af"))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(
                            Capsule().fill(
                                selectedTag == nil
                                    ? Color(hex: "6366f1")
                                    : Color(hex: "1a1f35").opacity(0.6)
                            )
                        )
                        .overlay(
                            Capsule().strokeBorder(
                                selectedTag == nil ? Color.clear : Color.white.opacity(0.08),
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
            .padding(.horizontal, 20)
        }
        .padding(.bottom, 20)
    }

    private var worksSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("\(filteredWorks.count)作品")
                .font(.system(size: 12))
                .foregroundColor(Color(hex: "9ca3af"))
                .padding(.horizontal, 20)

            LazyVStack(spacing: 12) {
                ForEach(filteredWorks) { work in
                    NavigationLink(destination: ReadingView(work: work)) {
                        WorkCardView(work: work)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 20)
        }
        .padding(.bottom, 32)
    }
}

#Preview {
    NavigationStack {
        WorksListView()
    }
}
