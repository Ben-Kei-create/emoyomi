import SwiftUI

struct ReadingCard: View {
    let segment: TextSegment
    let readingMode: ReadingMode
    var fontScale: CGFloat = 1.0
    var backgroundStyle: ReadingBackground = .paper
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
    private var bodySize: CGFloat { 17 * fontScale }
    private var lineGap: CGFloat { 8 * fontScale }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            switch readingMode {
            case .original:
                glossaryText(segment.originalText, glossary: segment.glossaryEntries)
                    .font(DS.Fonts.serif(serifSize))
                    .foregroundColor(DS.Colors.textPaper)
                    .lineSpacing(lineGap)
            case .easy:
                Text(segment.easyText)
                    .font(DS.Fonts.body(bodySize))
                    .foregroundColor(DS.Colors.textPaper.opacity(0.9))
                    .lineSpacing(lineGap)
            case .emo:
                Text(segment.emoText)
                    .font(DS.Fonts.body(bodySize, weight: .light))
                    .foregroundColor(DS.Colors.accentPink.opacity(0.9))
                    .lineSpacing(lineGap + 2)
                    .italic()
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(DS.Spacing.xxl)
        .background(
            RoundedRectangle(cornerRadius: DS.Radius.xl)
                .fill(cardBackground)
                .shadow(color: .black.opacity(0.3), radius: 16, y: 4)
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
        var components: [(String, GlossaryEntry?)] = []
        var remaining = text

        for entry in glossary {
            if let range = remaining.range(of: entry.word) {
                let before = String(remaining[remaining.startIndex..<range.lowerBound])
                if !before.isEmpty {
                    components.append((before, nil))
                }
                components.append((entry.word, entry))
                remaining = String(remaining[range.upperBound...])
            }
        }
        if !remaining.isEmpty {
            components.append((remaining, nil))
        }

        return HStack(spacing: 0) {
            ForEach(Array(components.enumerated()), id: \.offset) { _, component in
                if let entry = component.1 {
                    Button(action: { onGlossaryTap(entry) }) {
                        Text(component.0)
                            .font(DS.Fonts.serif(serifSize))
                            .foregroundColor(DS.Colors.accentIndigo)
                            .underline(true, color: DS.Colors.accentIndigo.opacity(0.5))
                    }
                } else {
                    Text(component.0)
                }
            }
        }
    }
}

#Preview {
    ReadingCard(
        segment: WorksData.all[0].segments[0],
        readingMode: .original,
        onGlossaryTap: { _ in }
    )
    .padding()
    .background(DS.Colors.bgPrimary)
}
