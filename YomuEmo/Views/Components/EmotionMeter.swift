import SwiftUI

struct EmotionMeter: View {
    let emotionScores: [EmotionTag: Int]

    private var sortedEmotions: [(tag: EmotionTag, value: Int)] {
        emotionScores.map { (tag: $0.key, value: $0.value) }
            .sorted { $0.value > $1.value }
    }

    var body: some View {
        VStack(spacing: DS.Spacing.sm) {
            ForEach(sortedEmotions, id: \.tag) { item in
                HStack(spacing: DS.Spacing.sm) {
                    Text(item.tag.emoji)
                        .font(DS.Fonts.small())
                        .frame(width: 20)

                    Text(item.tag.rawValue)
                        .font(DS.Fonts.caption())
                        .foregroundColor(DS.Colors.textSecondary)
                        .frame(width: 56, alignment: .leading)

                    GeometryReader { geo in
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 2)
                                .fill(Color.white.opacity(0.05))
                                .frame(height: 6)

                            RoundedRectangle(cornerRadius: 2)
                                .fill(item.tag.color)
                                .frame(width: geo.size.width * Double(item.value) / 100.0, height: 6)
                        }
                    }
                    .frame(height: 6)

                    Text("\(item.value)")
                        .font(DS.Fonts.caption())
                        .foregroundColor(DS.Colors.textSecondary.opacity(0.5))
                        .frame(width: 24, alignment: .trailing)
                }
            }
        }
    }
}

#Preview {
    EmotionMeter(emotionScores: [.孤独: 90, .不安: 70, .自己嫌悪: 85])
        .padding()
        .background(DS.Colors.bgPrimary)
}
