import SwiftUI

struct LevelBadge: View {
    let xp: Int
    var compact: Bool = false

    private var level: ReaderLevel {
        ReaderLevel.current(for: xp)
    }

    var body: some View {
        if compact {
            compactView
        } else {
            fullView
        }
    }

    private var compactView: some View {
        HStack(spacing: DS.Spacing.xs) {
            Text(level.icon)
                .font(.system(size: 16))

            Text("Lv.\(level.level)")
                .font(DS.Fonts.body(12, weight: .bold))
                .foregroundColor(DS.Colors.accentWarm)
        }
        .padding(.horizontal, DS.Spacing.md)
        .padding(.vertical, 6)
        .background(
            Capsule()
                .fill(DS.Colors.bgCard.opacity(0.8))
                .overlay(
                    Capsule().strokeBorder(DS.Colors.accentWarm.opacity(0.3), lineWidth: 1)
                )
        )
    }

    private var fullView: some View {
        VStack(spacing: DS.Spacing.md) {
            Text(level.icon)
                .font(.system(size: 48))

            Text(level.title)
                .font(DS.Fonts.serifBold(20))
                .foregroundColor(DS.Colors.textPrimary)

            Text("Lv.\(level.level)")
                .font(DS.Fonts.body(14, weight: .bold))
                .foregroundColor(DS.Colors.accentWarm)
                .padding(.horizontal, DS.Spacing.lg)
                .padding(.vertical, DS.Spacing.xs)
                .background(
                    Capsule()
                        .fill(DS.Colors.accentWarm.opacity(0.15))
                )

            XPBar(xp: xp)
                .padding(.top, DS.Spacing.sm)
        }
    }
}

#Preview {
    VStack(spacing: DS.Spacing.xxl) {
        LevelBadge(xp: 450)
        LevelBadge(xp: 450, compact: true)
    }
    .padding(DS.Spacing.xl)
    .background(DS.Colors.bgPrimary)
}
