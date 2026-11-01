import SwiftUI

struct PollCard: View {
    let poll: Poll
    @State private var voted = false
    @State private var selectedIndex: Int?

    private let store = StoreManager.shared

    var body: some View {
        VStack(alignment: .leading, spacing: DS.Spacing.md) {
            HStack(spacing: DS.Spacing.sm) {
                Text("📊")
                    .font(.system(size: 16))
                Text("みんなの声")
                    .font(DS.Fonts.caption())
                    .foregroundColor(DS.Colors.accentPink)
                    .textCase(.uppercase)
                    .tracking(1)
            }

            Text(poll.question)
                .font(DS.Fonts.body(16, weight: .medium))
                .foregroundColor(DS.Colors.textPrimary)

            VStack(spacing: DS.Spacing.sm) {
                ForEach(Array(poll.options.enumerated()), id: \.element.id) { index, option in
                    if voted || store.hasVoted(pollId: poll.id.uuidString) {
                        pollResult(option: option, isSelected: selectedIndex == index)
                    } else {
                        Button {
                            withAnimation(.spring(response: 0.4)) {
                                selectedIndex = index
                                voted = true
                                store.recordVote(pollId: poll.id.uuidString)
                            }
                        } label: {
                            pollOptionButton(option: option)
                        }
                    }
                }
            }
        }
        .padding(DS.Spacing.xl)
        .background(
            RoundedRectangle(cornerRadius: DS.Radius.lg)
                .fill(DS.Colors.bgPaper.opacity(0.95))
                .shadow(color: .black.opacity(0.15), radius: 8, y: 2)
        )
        .onAppear {
            if store.hasVoted(pollId: poll.id.uuidString) {
                voted = true
            }
        }
    }

    private func pollOptionButton(option: PollOption) -> some View {
        Text(option.text)
            .font(DS.Fonts.body(14))
            .foregroundColor(DS.Colors.textPaper)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, DS.Spacing.lg)
            .padding(.vertical, DS.Spacing.md)
            .background(
                RoundedRectangle(cornerRadius: DS.Radius.sm)
                    .fill(Color.white.opacity(0.6))
                    .overlay(
                        RoundedRectangle(cornerRadius: DS.Radius.sm)
                            .strokeBorder(DS.Colors.textPaper.opacity(0.15), lineWidth: 1)
                    )
            )
    }

    private func pollResult(option: PollOption, isSelected: Bool) -> some View {
        VStack(spacing: DS.Spacing.xs) {
            HStack {
                Text(option.text)
                    .font(DS.Fonts.body(13, weight: isSelected ? .medium : .regular))
                    .foregroundColor(DS.Colors.textPaper)
                Spacer()
                Text("\(option.percentage)%")
                    .font(DS.Fonts.body(13, weight: .medium))
                    .foregroundColor(isSelected ? DS.Colors.accentIndigo : DS.Colors.textPaper.opacity(0.6))
            }

            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 3)
                        .fill(DS.Colors.textPaper.opacity(0.08))

                    RoundedRectangle(cornerRadius: 3)
                        .fill(isSelected ? DS.Colors.accentIndigo.opacity(0.6) : DS.Colors.softPink.opacity(0.5))
                        .frame(width: geo.size.width * Double(option.percentage) / 100.0)
                }
            }
            .frame(height: 6)
        }
        .padding(.horizontal, DS.Spacing.lg)
        .padding(.vertical, DS.Spacing.sm)
        .background(
            RoundedRectangle(cornerRadius: DS.Radius.sm)
                .fill(isSelected ? DS.Colors.accentIndigo.opacity(0.08) : Color.clear)
        )
    }
}

#Preview {
    PollCard(poll: Poll(
        question: "葉蔵に共感する？",
        options: [
            PollOption(text: "とても共感する", percentage: 52),
            PollOption(text: "少し共感する", percentage: 30),
            PollOption(text: "あまり共感しない", percentage: 12),
            PollOption(text: "共感しない", percentage: 6),
        ]
    ))
    .padding()
    .background(DS.Colors.bgPrimary)
}
