import SwiftUI

struct GlossaryPopup: View {
    let entry: GlossaryEntry
    let onClose: () -> Void

    var body: some View {
        ZStack {
            Color.black.opacity(0.6)
                .ignoresSafeArea()
                .onTapGesture { onClose() }

            VStack(alignment: .leading, spacing: 0) {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(entry.word)
                            .font(DS.Fonts.body(22, weight: .bold))
                            .foregroundColor(DS.Colors.textPrimary)

                        Text(entry.reading)
                            .font(DS.Fonts.body(13))
                            .foregroundColor(DS.Colors.accentNeon)
                    }

                    Spacer()

                    Button(action: onClose) {
                        Image(systemName: AssetNames.Icons.close)
                            .font(DS.Fonts.small().weight(.medium))
                            .foregroundColor(DS.Colors.textSecondary)
                            .frame(width: 32, height: 32)
                            .background(Circle().fill(Color.white.opacity(0.05)))
                    }
                }
                .padding(.bottom, DS.Spacing.lg)

                VStack(alignment: .leading, spacing: DS.Spacing.xs) {
                    Text("意味")
                        .font(DS.Fonts.caption())
                        .foregroundColor(DS.Colors.textSecondary)
                        .textCase(.uppercase)
                        .tracking(1)

                    Text(entry.meaning)
                        .font(DS.Fonts.body(14))
                        .foregroundColor(DS.Colors.textPrimary)
                }
                .padding(.bottom, DS.Spacing.lg)

                Rectangle()
                    .fill(DS.Colors.borderSubtle)
                    .frame(height: 1)
                    .padding(.bottom, DS.Spacing.lg)

                VStack(alignment: .leading, spacing: DS.Spacing.xs) {
                    Text("バイブス訳")
                        .font(DS.Fonts.caption())
                        .foregroundColor(DS.Colors.accentPink)
                        .textCase(.uppercase)
                        .tracking(1)

                    Text(entry.vibes)
                        .font(DS.Fonts.body(14))
                        .foregroundColor(DS.Colors.textPrimary)
                }
            }
            .padding(DS.Spacing.xl)
            .background(
                RoundedRectangle(cornerRadius: DS.Radius.xl)
                    .fill(DS.Colors.bgCard.opacity(0.95))
                    .overlay(
                        RoundedRectangle(cornerRadius: DS.Radius.xl)
                            .strokeBorder(DS.Colors.borderSubtle, lineWidth: 1)
                    )
            )
            .padding(.horizontal, DS.Spacing.xxl)
            .transition(.move(edge: .bottom).combined(with: .opacity))
        }
    }
}

#Preview {
    GlossaryPopup(
        entry: GlossaryEntry(
            word: "転輾",
            reading: "てんてん",
            meaning: "眠れずに何度も寝返りをうつこと",
            vibes: "深夜3時にスマホ見ながら寝返りしまくるあの感じ"
        ),
        onClose: {}
    )
}
