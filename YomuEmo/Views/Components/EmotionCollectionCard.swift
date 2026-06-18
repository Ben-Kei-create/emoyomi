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
                        ? tag.color.opacity(mastery.opacity * 0.2)
                        : Color.white.opacity(0.03))
                    .frame(height: 80)

                if isDiscovered {
                    RoundedRectangle(cornerRadius: DS.Radius.md)
                        .strokeBorder(tag.color.opacity(mastery.opacity * 0.4), lineWidth: 1)
                        .frame(height: 80)
                }

                VStack(spacing: DS.Spacing.xs) {
                    Text(isDiscovered ? tag.emoji : "?")
                        .font(.system(size: 28))
                        .grayscale(isDiscovered ? 0 : 1)
                        .opacity(isDiscovered ? 1 : 0.2)

                    if isDiscovered {
                        Text(mastery.icon)
                            .font(DS.Fonts.caption())
                            .foregroundColor(tag.color)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(
                                Capsule().fill(tag.color.opacity(0.15))
                            )
                    }
                }
            }

            Text(isDiscovered ? tag.rawValue : "???")
                .font(DS.Fonts.body(11, weight: .medium))
                .foregroundColor(isDiscovered ? DS.Colors.textPrimary : DS.Colors.textSecondary.opacity(0.3))

            if let entry = entry {
                Text("\(entry.encounters)回")
                    .font(DS.Fonts.caption())
                    .foregroundColor(DS.Colors.textSecondary)
            }
        }
    }
}

#Preview {
    HStack(spacing: DS.Spacing.md) {
        EmotionCollectionCard(tag: .孤独, entry: EmotionCollectionEntry(
            emotionRawValue: "孤独",
            encounters: 5,
            maxIntensity: 85,
            totalIntensity: 300,
            firstEncountered: Date(),
            sourceWorkIds: ["ningen-shikkaku"]
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
