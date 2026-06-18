import SwiftUI

struct EmotionCollectionCard: View {
    let tag: EmotionTag
    let entry: EmotionCollectionEntry?

    private var isDiscovered: Bool { entry != nil }
    private var mastery: EmotionMastery { entry?.masteryLevel ?? .undiscovered }

    var body: some View {
        VStack(spacing: DS.Spacing.sm) {
            ZStack {
                RoundedRectangle(cornerRadius: DS.Radius.md)
                    .fill(isDiscovered
                        ? tag.color.opacity(mastery.opacity * 0.15)
                        : Color.white.opacity(0.02))
                    .frame(height: 88)

                if isDiscovered {
                    RoundedRectangle(cornerRadius: DS.Radius.md)
                        .strokeBorder(tag.color.opacity(mastery.opacity * 0.3), lineWidth: 1)
                        .frame(height: 88)
                } else {
                    RoundedRectangle(cornerRadius: DS.Radius.md)
                        .strokeBorder(Color.white.opacity(0.04), lineWidth: 1)
                        .frame(height: 88)
                }

                VStack(spacing: DS.Spacing.xs) {
                    Text(isDiscovered ? tag.emoji : "?")
                        .font(.system(size: 28))
                        .grayscale(isDiscovered ? 0 : 1)
                        .opacity(isDiscovered ? 1 : 0.15)

                    if let entry = entry {
                        HStack(spacing: 2) {
                            ForEach(0..<4, id: \.self) { i in
                                let filled = masteryIndex(mastery) > i
                                RoundedRectangle(cornerRadius: 1)
                                    .fill(filled
                                        ? tag.color.opacity(mastery.opacity)
                                        : Color.white.opacity(0.08))
                                    .frame(width: 12, height: 3)
                            }
                        }

                        Text(mastery.rawValue)
                            .font(.system(size: 8, weight: .medium))
                            .foregroundColor(tag.color.opacity(mastery.opacity))
                    }
                }
            }

            Text(isDiscovered ? tag.rawValue : "???")
                .font(DS.Fonts.body(11, weight: .medium))
                .foregroundColor(isDiscovered
                    ? DS.Colors.textPrimary.opacity(mastery.opacity)
                    : DS.Colors.textSecondary.opacity(0.2))
        }
    }

    private func masteryIndex(_ mastery: EmotionMastery) -> Int {
        switch mastery {
        case .undiscovered: return 0
        case .encountered: return 1
        case .familiar: return 2
        case .mastered: return 4
        }
    }
}

#Preview {
    HStack(spacing: DS.Spacing.md) {
        EmotionCollectionCard(tag: .孤独, entry: EmotionCollectionEntry(
            emotionRawValue: "孤独",
            encounters: 12,
            maxIntensity: 85,
            totalIntensity: 600,
            firstEncountered: Date(),
            sourceWorkIds: ["ningen-shikkaku", "kokoro"]
        ))

        EmotionCollectionCard(tag: .希望, entry: EmotionCollectionEntry(
            emotionRawValue: "希望",
            encounters: 1,
            maxIntensity: 40,
            totalIntensity: 40,
            firstEncountered: Date(),
            sourceWorkIds: ["hashire-melos"]
        ))

        EmotionCollectionCard(tag: .怒り, entry: nil)
    }
    .padding(DS.Spacing.xl)
    .background(DS.Colors.bgPrimary)
}
