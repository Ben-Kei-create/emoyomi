import SwiftUI

struct PrimaryButton: View {
    let title: String
    let action: () -> Void
    var width: CGFloat? = nil
    var height: CGFloat = 56

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(DS.Fonts.body(18, weight: .medium))
                .foregroundColor(.white)
                .frame(width: width, maxWidth: width == nil ? .infinity : nil)
                .frame(height: height)
                .background(
                    Capsule()
                        .fill(DS.Colors.accentIndigo)
                        .shadow(color: DS.Colors.accentIndigo.opacity(0.4), radius: 16, y: 4)
                )
        }
    }
}

struct SecondaryButton: View {
    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(DS.Fonts.body(14))
                .foregroundColor(DS.Colors.textSecondary)
                .frame(maxWidth: .infinity)
                .frame(height: 48)
                .background(
                    Capsule()
                        .fill(DS.Colors.bgCard.opacity(0.6))
                        .overlay(
                            Capsule().strokeBorder(DS.Colors.borderSubtle, lineWidth: 1)
                        )
                )
        }
    }
}

#Preview {
    VStack(spacing: 16) {
        PrimaryButton(title: "はじめる", action: {}, width: 200)
        SecondaryButton(title: "文豪を見る", action: {})
    }
    .padding()
    .background(DS.Colors.bgPrimary)
}
