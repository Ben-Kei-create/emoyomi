import SwiftUI

struct EmotionMeterView: View {
    let emotions: [EmotionTag: Int]

    private var sortedEmotions: [(tag: EmotionTag, value: Int)] {
        emotions.map { (tag: $0.key, value: $0.value) }
            .sorted { $0.value > $1.value }
    }

    var body: some View {
        VStack(spacing: 8) {
            ForEach(sortedEmotions, id: \.tag) { item in
                HStack(spacing: 8) {
                    Text(item.tag.emoji)
                        .font(.system(size: 12))
                        .frame(width: 20)

                    Text(item.tag.rawValue)
                        .font(.system(size: 10))
                        .foregroundColor(Color(hex: "9ca3af"))
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
                        .font(.system(size: 10))
                        .foregroundColor(Color(hex: "9ca3af").opacity(0.5))
                        .frame(width: 24, alignment: .trailing)
                }
            }
        }
    }
}

#Preview {
    EmotionMeterView(emotions: [.孤独: 90, .不安: 70, .自己嫌悪: 85])
        .padding()
        .background(Color(hex: "0a0e1a"))
}
