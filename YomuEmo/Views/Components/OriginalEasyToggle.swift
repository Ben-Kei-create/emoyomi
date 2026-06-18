import SwiftUI

struct OriginalEasyToggle: View {
    @Binding var textMode: TextMode

    var body: some View {
        HStack(spacing: 0) {
            ForEach([TextMode.original, TextMode.easy], id: \.rawValue) { mode in
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        textMode = mode
                    }
                }) {
                    Text(mode.rawValue)
                        .font(DS.Fonts.small())
                        .fontWeight(.medium)
                        .foregroundColor(textMode == mode ? .white : DS.Colors.textSecondary)
                        .padding(.horizontal, DS.Spacing.lg)
                        .padding(.vertical, DS.Spacing.sm)
                        .background(
                            Capsule()
                                .fill(textMode == mode ? DS.Colors.accentIndigo : Color.clear)
                        )
                }
            }
        }
        .padding(3)
        .background(
            Capsule()
                .fill(DS.Colors.bgCard.opacity(0.8))
                .overlay(
                    Capsule().strokeBorder(DS.Colors.borderSubtle, lineWidth: 1)
                )
        )
    }
}

#Preview {
    OriginalEasyToggle(textMode: .constant(.original))
        .padding()
        .background(DS.Colors.bgPrimary)
}
