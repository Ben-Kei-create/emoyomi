import SwiftUI

struct CompletionView: View {
    let work: Work
    @Environment(\.dismiss) private var dismiss
    @State private var showContent = false

    var body: some View {
        ZStack {
            Color(hex: "0a0e1a").ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    Spacer().frame(height: 80)

                    Text(work.coverEmoji)
                        .font(.system(size: 64))
                        .padding(.bottom, 20)
                        .opacity(showContent ? 1 : 0)
                        .scaleEffect(showContent ? 1 : 0.5)

                    Text("読了")
                        .font(.custom("HiraginoSans-W7", size: 28))
                        .foregroundColor(Color(hex: "e8e2d6"))
                        .padding(.bottom, 8)
                        .opacity(showContent ? 1 : 0)
                        .offset(y: showContent ? 0 : 16)

                    Text("\(work.title) ── \(work.authorName)")
                        .font(.system(size: 14))
                        .foregroundColor(Color(hex: "9ca3af"))
                        .padding(.bottom, 32)
                        .opacity(showContent ? 1 : 0)
                        .offset(y: showContent ? 0 : 16)

                    VStack(spacing: 12) {
                        afterwordCard(
                            label: "テーマ",
                            text: work.afterword.theme,
                            color: Color(hex: "818cf8")
                        )

                        afterwordCard(
                            label: "刺さるポイント",
                            text: work.afterword.point,
                            color: Color(hex: "ec4899")
                        )

                        afterwordCard(
                            label: "現代との共通点",
                            text: work.afterword.modern,
                            color: Color(hex: "f59e0b")
                        )

                        emotionTagsCard
                    }
                    .padding(.horizontal, 20)
                    .opacity(showContent ? 1 : 0)
                    .offset(y: showContent ? 0 : 24)

                    HStack(spacing: 12) {
                        NavigationLink(destination: AuthorProfileView(
                            author: AuthorsData.find(by: work.authorId)!
                        )) {
                            Text("文豪を見る")
                                .font(.system(size: 14))
                                .foregroundColor(Color(hex: "9ca3af"))
                                .frame(maxWidth: .infinity)
                                .frame(height: 48)
                                .background(
                                    Capsule()
                                        .fill(Color(hex: "1a1f35").opacity(0.6))
                                        .overlay(
                                            Capsule()
                                                .strokeBorder(Color.white.opacity(0.08), lineWidth: 1)
                                        )
                                )
                        }

                        Button(action: { dismiss() }) {
                            Text("ホームに戻る")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 48)
                                .background(
                                    Capsule().fill(Color(hex: "6366f1"))
                                )
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 32)
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

    private func afterwordCard(label: String, text: String, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label)
                .font(.system(size: 10, weight: .medium))
                .foregroundColor(color)
                .textCase(.uppercase)
                .tracking(1)

            Text(text)
                .font(.system(size: 14))
                .foregroundColor(Color(hex: "e8e2d6"))
                .lineSpacing(4)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(hex: "1a1f35").opacity(0.6))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .strokeBorder(Color.white.opacity(0.08), lineWidth: 1)
                )
        )
    }

    private var emotionTagsCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("この作品の感情")
                .font(.system(size: 10, weight: .medium))
                .foregroundColor(Color(hex: "9ca3af"))
                .textCase(.uppercase)
                .tracking(1)

            FlowLayout(spacing: 8) {
                ForEach(work.tags) { tag in
                    HStack(spacing: 4) {
                        Text(tag.emoji)
                            .font(.system(size: 12))
                        Text(tag.rawValue)
                            .font(.system(size: 12))
                    }
                    .foregroundColor(Color(hex: "9ca3af"))
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(
                        Capsule().fill(Color.white.opacity(0.05))
                    )
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
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
