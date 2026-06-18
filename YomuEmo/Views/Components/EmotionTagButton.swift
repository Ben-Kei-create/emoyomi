import SwiftUI

struct EmotionTagButton: View {
    let tag: EmotionTag
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: DS.Spacing.xs) {
                Text(tag.emoji)
                    .font(DS.Fonts.body(13))
                Text(tag.rawValue)
                    .font(DS.Fonts.body(13))
            }
            .padding(.horizontal, DS.Spacing.md + 2)
            .padding(.vertical, DS.Spacing.sm + 2)
            .background(
                Capsule()
                    .fill(isSelected ? tag.color : DS.Colors.bgCard.opacity(0.6))
            )
            .overlay(
                Capsule()
                    .strokeBorder(
                        isSelected ? Color.clear : DS.Colors.borderSubtle,
                        lineWidth: 1
                    )
            )
            .foregroundColor(isSelected ? .white : DS.Colors.textSecondary)
            .shadow(color: isSelected ? tag.color.opacity(0.3) : .clear, radius: 8, y: 2)
        }
    }
}

#Preview {
    HStack {
        EmotionTagButton(tag: .孤独, isSelected: true, action: {})
        EmotionTagButton(tag: .希望, isSelected: false, action: {})
    }
    .padding()
    .background(DS.Colors.bgPrimary)
}
