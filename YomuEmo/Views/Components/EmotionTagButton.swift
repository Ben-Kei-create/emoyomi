import SwiftUI

struct EmotionTagButton: View {
    let tag: EmotionTag
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 4) {
                Text(tag.emoji)
                    .font(.system(size: 13))
                Text(tag.rawValue)
                    .font(.system(size: 13))
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .background(
                Capsule()
                    .fill(isSelected ? tag.color : Color(hex: "1a1f35").opacity(0.6))
            )
            .overlay(
                Capsule()
                    .strokeBorder(
                        isSelected ? Color.clear : Color.white.opacity(0.08),
                        lineWidth: 1
                    )
            )
            .foregroundColor(isSelected ? .white : Color(hex: "9ca3af"))
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
    .background(Color(hex: "0a0e1a"))
}
