import SwiftUI

struct QuoteCard: View {
    let quote: SavedQuote
    var onDelete: (() -> Void)?

    private var dateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        return formatter.string(from: quote.savedAt)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: DS.Spacing.md) {
            Text("「\(quote.text)」")
                .font(DS.Fonts.serif(15))
                .foregroundColor(DS.Colors.textPaper)
                .lineSpacing(6)

            Rectangle()
                .fill(DS.Colors.textPaper.opacity(0.1))
                .frame(height: 1)

            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(quote.workTitle)
                        .font(DS.Fonts.body(12, weight: .medium))
                        .foregroundColor(DS.Colors.textPaper.opacity(0.8))
                    Text(quote.authorName)
                        .font(DS.Fonts.body(11))
                        .foregroundColor(DS.Colors.textPaper.opacity(0.5))
                }

                Spacer()

                Text(dateString)
                    .font(DS.Fonts.body(10))
                    .foregroundColor(DS.Colors.textPaper.opacity(0.4))

                if let onDelete {
                    Button(action: onDelete) {
                        Image(systemName: "trash")
                            .font(.system(size: 12))
                            .foregroundColor(DS.Colors.textPaper.opacity(0.3))
                    }
                }
            }
        }
        .padding(DS.Spacing.xl)
        .background(
            RoundedRectangle(cornerRadius: DS.Radius.md)
                .fill(DS.Gradients.stickyNote)
                .shadow(color: .black.opacity(0.1), radius: 4, y: 2)
        )
        .rotationEffect(.degrees(Double.random(in: -1.5...1.5)))
    }
}

#Preview {
    VStack(spacing: 16) {
        QuoteCard(
            quote: SavedQuote(
                text: "恥の多い生涯を送って来ました。",
                workId: "ningen-shikkaku",
                workTitle: "人間失格",
                authorId: "dazai",
                authorName: "太宰治"
            ),
            onDelete: {}
        )
        QuoteCard(
            quote: SavedQuote(
                text: "ほんとうのさいわいは一体何だろう。",
                workId: "ginga-tetsudo",
                workTitle: "銀河鉄道の夜",
                authorId: "miyazawa",
                authorName: "宮沢賢治"
            )
        )
    }
    .padding()
    .background(DS.Colors.bgPrimary)
}
