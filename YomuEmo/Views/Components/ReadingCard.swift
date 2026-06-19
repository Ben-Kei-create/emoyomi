import SwiftUI

struct ReadingCard: View {
    let text: String
    let glossaryEntries: [GlossaryEntry]
    var fontScale: CGFloat = 1.0
    var backgroundStyle: ReadingBackground = .paper
    var showBackground: Bool = true
    let onGlossaryTap: (GlossaryEntry) -> Void

    private var cardBackground: AnyShapeStyle {
        switch backgroundStyle {
        case .paper:
            return AnyShapeStyle(DS.Gradients.paperCard)
        case .cream:
            return AnyShapeStyle(
                LinearGradient(
                    colors: [DS.Colors.warmIvory, DS.Colors.warmIvory.opacity(0.9)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
        case .white:
            return AnyShapeStyle(Color.white.opacity(0.95))
        }
    }

    private var serifSize: CGFloat { 18 * fontScale }
    private var lineGap: CGFloat { 8 * fontScale }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            glossaryText(text, glossary: glossaryEntries)
                .font(DS.Fonts.serif(serifSize))
                .foregroundColor(DS.Colors.textPaper)
                .lineSpacing(lineGap)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(DS.Spacing.xxl)
        .background(
            Group {
                if showBackground {
                    RoundedRectangle(cornerRadius: DS.Radius.xl)
                        .fill(cardBackground)
                        .shadow(color: .black.opacity(0.3), radius: 16, y: 4)
                }
            }
        )
    }

    @ViewBuilder
    private func glossaryText(_ text: String, glossary: [GlossaryEntry]) -> some View {
        if glossary.isEmpty {
            Text(text)
        } else {
            buildAnnotatedText(text, glossary: glossary)
        }
    }

    private func buildAnnotatedText(_ text: String, glossary: [GlossaryEntry]) -> some View {
        var attrStr = AttributedString(text)
        for (index, entry) in glossary.enumerated() {
            if let range = attrStr.range(of: entry.word) {
                attrStr[range].link = URL(string: "glossary://word/\(index)")
                attrStr[range].underlineStyle = Text.LineStyle(
                    pattern: .solid, color: DS.Colors.accentIndigo.opacity(0.5)
                )
            }
        }
        return Text(attrStr)
            .tint(DS.Colors.accentIndigo)
            .environment(\.openURL, OpenURLAction { url in
                if url.scheme == "glossary",
                   let index = Int(url.lastPathComponent),
                   index < glossary.count {
                    onGlossaryTap(glossary[index])
                }
                return .handled
            })
    }
}

#Preview {
    let segment = WorksData.all[0].segments[0]
    ReadingCard(
        text: segment.originalText,
        glossaryEntries: segment.glossaryEntries,
        onGlossaryTap: { _ in }
    )
    .padding()
    .background(DS.Colors.bgPrimary)
}
