import SwiftUI

struct ReadingModeToggle: View {
    @Binding var readingMode: ReadingMode

    var body: some View {
        HStack(spacing: 0) {
            ForEach(ReadingMode.allCases, id: \.rawValue) { mode in
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        readingMode = mode
                    }
                }) {
                    Text(mode == .emo ? "エモ訳" : mode.rawValue)
                        .font(DS.Fonts.body(11, weight: .medium))
                        .foregroundColor(readingMode == mode ? .white : DS.Colors.textSecondary)
                        .padding(.horizontal, DS.Spacing.md)
                        .padding(.vertical, DS.Spacing.sm)
                        .background(
                            Capsule()
                                .fill(readingMode == mode ? modeColor(mode) : Color.clear)
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

    private func modeColor(_ mode: ReadingMode) -> Color {
        switch mode {
        case .original: return DS.Colors.accentIndigo
        case .easy: return DS.Colors.accentNeon
        case .emo: return DS.Colors.accentPink
        }
    }
}

#Preview {
    ReadingModeToggle(readingMode: .constant(.original))
        .padding()
        .background(DS.Colors.bgPrimary)
}
