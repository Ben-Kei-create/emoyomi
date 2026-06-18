import SwiftUI

struct ReadingCard: View {
    let segment: TextSegment
    let textMode: TextMode
    let onGlossaryTap: (GlossaryEntry) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if textMode == .original {
                glossaryText(segment.originalText, glossary: segment.glossaryEntries)
                    .font(DS.Fonts.serif(18))
                    .foregroundColor(DS.Colors.textPaper)
                    .lineSpacing(8)
            } else {
                Text(segment.easyText)
                    .font(DS.Fonts.body(17))
                    .foregroundColor(DS.Colors.textPaper.opacity(0.9))
                    .lineSpacing(8)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(DS.Spacing.xxl)
        .background(
            RoundedRectangle(cornerRadius: DS.Radius.xl)
                .fill(DS.Gradients.paperCard)
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
                            .font(DS.Fonts.serif(18))
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
        textMode: .original,
        onGlossaryTap: { _ in }
    )
    .padding()
    .background(DS.Colors.bgPrimary)
}
