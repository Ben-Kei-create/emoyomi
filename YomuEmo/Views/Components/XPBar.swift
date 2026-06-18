import SwiftUI

struct XPBar: View {
    let currentXP: Int
    let level: ReaderLevel
    let nextLevel: ReaderLevel?
    let progress: Double

    init(xp: Int) {
        self.currentXP = xp
        self.level = ReaderLevel.current(for: xp)
        self.nextLevel = ReaderLevel.next(for: xp)
        self.progress = ReaderLevel.progressToNext(for: xp)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: DS.Spacing.sm) {
            HStack {
                Text("Lv.\(level.level)")
                    .font(DS.Fonts.body(12, weight: .bold))
                    .foregroundColor(DS.Colors.accentWarm)

                Text(level.title)
                    .font(DS.Fonts.body(12, weight: .medium))
                    .foregroundColor(DS.Colors.textPrimary)

                Spacer()

                if let next = nextLevel {
                    Text("\(currentXP - level.requiredXP)/\(next.requiredXP - level.requiredXP) XP")
                        .font(DS.Fonts.caption())
                        .foregroundColor(DS.Colors.textSecondary)
                } else {
                    Text("MAX")
                        .font(DS.Fonts.caption())
                        .foregroundColor(DS.Colors.accentWarm)
                }
            }

            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.white.opacity(0.08))

                    RoundedRectangle(cornerRadius: 4)
                        .fill(DS.Gradients.xpBar)
                        .frame(width: geo.size.width * progress)
                }
            }
            .frame(height: 8)
        }
    }
}

#Preview {
    VStack(spacing: DS.Spacing.xl) {
        XPBar(xp: 0)
        XPBar(xp: 150)
        XPBar(xp: 1200)
        XPBar(xp: 5500)
    }
    .padding(DS.Spacing.xl)
    .background(DS.Colors.bgPrimary)
}
