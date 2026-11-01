import SwiftUI

struct AuthorProfileView: View {
    let author: Author
    @Environment(\.dismiss) private var dismiss

    private var authorWorks: [Work] {
        WorksData.works(for: author.id)
    }

    var body: some View {
        ZStack {
            DS.Colors.bgPrimary.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {
                    backButton
                    profileCard
                    worksSection
                }
            }
        }
        .navigationBarHidden(true)
    }

    private var backButton: some View {
        Button(action: { dismiss() }) {
            Text("← 戻る")
                .font(DS.Fonts.body(14))
                .foregroundColor(DS.Colors.textSecondary)
        }
        .padding(.horizontal, DS.Spacing.xl)
        .padding(.top, DS.Spacing.md)
        .padding(.bottom, DS.Spacing.lg)
    }

    private var profileCard: some View {
        VStack(alignment: .leading, spacing: DS.Spacing.lg) {
            HStack(alignment: .top, spacing: DS.Spacing.lg) {
                Text(author.icon)
                    .font(.system(size: 36))
                    .frame(width: 64, height: 64)
                    .background(
                        Circle().fill(DS.Colors.accentIndigo.opacity(0.2))
                    )

                VStack(alignment: .leading, spacing: DS.Spacing.xs) {
                    Text(author.name)
                        .font(DS.Fonts.serifBold(24))
                        .foregroundColor(DS.Colors.textPrimary)

                    Text("\(author.born)–\(author.died)")
                        .font(DS.Fonts.small())
                        .foregroundColor(DS.Colors.textSecondary)
                }

                Spacer()
            }

            Text(author.bio)
                .font(DS.Fonts.body(14))
                .foregroundColor(DS.Colors.textPrimary)
                .lineSpacing(4)

            FlowLayout(spacing: DS.Spacing.sm) {
                ForEach(author.tags) { tag in
                    HStack(spacing: DS.Spacing.xs) {
                        Text(tag.emoji)
                            .font(DS.Fonts.small())
                        Text(tag.rawValue)
                            .font(DS.Fonts.small())
                    }
                    .foregroundColor(tag.color)
                    .padding(.horizontal, DS.Spacing.md)
                    .padding(.vertical, 6)
                    .background(
                        Capsule().fill(tag.color.opacity(0.15))
                    )
                }
            }
        }
        .padding(DS.Spacing.xl)
        .glassCard(cornerRadius: DS.Radius.xl)
        .padding(.horizontal, DS.Spacing.xl)
        .padding(.bottom, 28)
    }

    private var worksSection: some View {
        VStack(alignment: .leading, spacing: DS.Spacing.md) {
            Text("作品")
                .sectionHeader()
                .padding(.horizontal, DS.Spacing.xl)

            LazyVStack(spacing: DS.Spacing.md) {
                ForEach(authorWorks) { work in
                    NavigationLink(destination: ReadingView(work: work)) {
                        WorkCard(work: work)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, DS.Spacing.xl)
        }
        .padding(.bottom, DS.Spacing.xxxl)
    }
}

#Preview {
    NavigationStack {
        AuthorProfileView(author: AuthorsData.all[0])
    }
}
