import SwiftUI

struct GlossaryPopupView: View {
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
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(Color(hex: "e8e2d6"))

                        Text(entry.reading)
                            .font(.system(size: 13))
                            .foregroundColor(Color(hex: "818cf8"))
                    }

                    Spacer()

                    Button(action: onClose) {
                        Image(systemName: "xmark")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(Color(hex: "9ca3af"))
                            .frame(width: 32, height: 32)
                            .background(Circle().fill(Color.white.opacity(0.05)))
                    }
                }
                .padding(.bottom, 16)

                VStack(alignment: .leading, spacing: 4) {
                    Text("意味")
                        .font(.system(size: 10, weight: .medium))
                        .foregroundColor(Color(hex: "9ca3af"))
                        .textCase(.uppercase)
                        .tracking(1)

                    Text(entry.meaning)
                        .font(.system(size: 14))
                        .foregroundColor(Color(hex: "e8e2d6"))
                }
                .padding(.bottom, 16)

                Rectangle()
                    .fill(Color.white.opacity(0.08))
                    .frame(height: 1)
                    .padding(.bottom, 16)

                VStack(alignment: .leading, spacing: 4) {
                    Text("バイブス訳")
                        .font(.system(size: 10, weight: .medium))
                        .foregroundColor(Color(hex: "ec4899"))
                        .textCase(.uppercase)
                        .tracking(1)

                    Text(entry.vibes)
                        .font(.system(size: 14))
                        .foregroundColor(Color(hex: "e8e2d6"))
                }
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color(hex: "1a1f35").opacity(0.95))
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .strokeBorder(Color.white.opacity(0.08), lineWidth: 1)
                    )
            )
            .padding(.horizontal, 24)
            .transition(.move(edge: .bottom).combined(with: .opacity))
        }
    }
}

#Preview {
    GlossaryPopupView(
        entry: GlossaryEntry(
            word: "転輾",
            reading: "てんてん",
            meaning: "眠れずに何度も寝返りをうつこと",
            vibes: "深夜3時にスマホ見ながら寝返りしまくるあの感じ"
        ),
        onClose: {}
    )
}
