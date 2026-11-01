import SwiftUI

struct WorkCard: View {
    let work: Work

    var body: some View {
        HStack(alignment: .top, spacing: DS.Spacing.md) {
            Text(work.coverEmoji)
                .font(.system(size: 32))
                .padding(.top, 2)

            VStack(alignment: .leading, spacing: DS.Spacing.xs) {
                HStack(spacing: DS.Spacing.sm) {
                    Text(work.title)
                        .font(DS.Fonts.body(16, weight: .medium))
                        .foregroundColor(DS.Colors.textPrimary)

                    if work.isPremium {
                        Text("Premium")
                            .font(.system(size: 9, weight: .medium))
                            .foregroundColor(DS.Colors.accentWarm)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(
                                Capsule().fill(DS.Colors.accentWarm.opacity(0.2))
                            )
                    }
                }

                Text("\(work.authorName) ・ \(work.readTime)")
                    .font(DS.Fonts.small())
                    .foregroundColor(DS.Colors.textSecondary)

                Text(work.description)
                    .font(DS.Fonts.small())
                    .foregroundColor(DS.Colors.textSecondary.opacity(0.7))
                    .lineLimit(1)
                    .padding(.top, 2)

                HStack(spacing: 6) {
                    ForEach(work.tags) { tag in
                        Text(tag.rawValue)
                            .font(DS.Fonts.caption())
                            .foregroundColor(DS.Colors.textSecondary.opacity(0.6))
                            .padding(.horizontal, DS.Spacing.sm)
                            .padding(.vertical, 3)
                            .background(
                                Capsule().fill(Color.white.opacity(0.05))
                            )
                    }
                }
                .padding(.top, DS.Spacing.xs)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(DS.Spacing.lg)
        .glassCard()
    }
}

#Preview {
    WorkCard(work: WorksData.all[0])
        .padding()
        .background(DS.Colors.bgPrimary)
}
