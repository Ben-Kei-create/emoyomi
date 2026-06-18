import SwiftUI

struct AuthorProfileView: View {
    let author: Author
    @Environment(\.dismiss) private var dismiss

    private var authorWorks: [Work] {
        WorksData.works(for: author.id)
    }

    var body: some View {
        ZStack {
            Color(hex: "0a0e1a").ignoresSafeArea()

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
                .font(.system(size: 14))
                .foregroundColor(Color(hex: "9ca3af"))
        }
        .padding(.horizontal, 20)
        .padding(.top, 12)
        .padding(.bottom, 16)
    }

    private var profileCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .top, spacing: 16) {
                Text(author.icon)
                    .font(.system(size: 36))
                    .frame(width: 64, height: 64)
                    .background(
                        Circle().fill(Color(hex: "6366f1").opacity(0.2))
                    )

                VStack(alignment: .leading, spacing: 4) {
                    Text(author.name)
                        .font(.custom("HiraginoSans-W7", size: 24))
                        .foregroundColor(Color(hex: "e8e2d6"))

                    Text("\(author.born)–\(author.died)")
                        .font(.system(size: 12))
                        .foregroundColor(Color(hex: "9ca3af"))
                }

                Spacer()
            }

            Text(author.bio)
                .font(.system(size: 14))
                .foregroundColor(Color(hex: "e8e2d6"))
                .lineSpacing(4)

            FlowLayout(spacing: 8) {
                ForEach(author.tags) { tag in
                    HStack(spacing: 4) {
                        Text(tag.emoji)
                            .font(.system(size: 12))
                        Text(tag.rawValue)
                            .font(.system(size: 12))
                    }
                    .foregroundColor(tag.color)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(
                        Capsule().fill(tag.color.opacity(0.15))
                    )
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(hex: "1a1f35").opacity(0.6))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .strokeBorder(Color.white.opacity(0.08), lineWidth: 1)
                )
        )
        .padding(.horizontal, 20)
        .padding(.bottom, 28)
    }

    private var worksSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("作品")
                .font(.system(size: 11, weight: .medium))
                .foregroundColor(Color(hex: "9ca3af"))
                .textCase(.uppercase)
                .tracking(1)
                .padding(.horizontal, 20)

            LazyVStack(spacing: 12) {
                ForEach(authorWorks) { work in
                    NavigationLink(destination: ReadingView(work: work)) {
                        WorkCardView(work: work)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 20)
        }
        .padding(.bottom, 32)
    }
}

#Preview {
    NavigationStack {
        AuthorProfileView(author: AuthorsData.all[0])
    }
}
