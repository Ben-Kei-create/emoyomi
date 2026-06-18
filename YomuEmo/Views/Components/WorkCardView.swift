import SwiftUI

struct WorkCardView: View {
    let work: Work

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Text(work.coverEmoji)
                .font(.system(size: 32))
                .padding(.top, 2)

            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 8) {
                    Text(work.title)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(Color(hex: "e8e2d6"))

                    if work.isPremium {
                        Text("Premium")
                            .font(.system(size: 9, weight: .medium))
                            .foregroundColor(Color(hex: "f59e0b"))
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(
                                Capsule().fill(Color(hex: "f59e0b").opacity(0.2))
                            )
                    }
                }

                Text("\(work.authorName) ・ \(work.readTime)")
                    .font(.system(size: 12))
                    .foregroundColor(Color(hex: "9ca3af"))

                Text(work.description)
                    .font(.system(size: 12))
                    .foregroundColor(Color(hex: "9ca3af").opacity(0.7))
                    .lineLimit(1)
                    .padding(.top, 2)

                HStack(spacing: 6) {
                    ForEach(work.tags) { tag in
                        Text(tag.rawValue)
                            .font(.system(size: 10))
                            .foregroundColor(Color(hex: "9ca3af").opacity(0.6))
                            .padding(.horizontal, 8)
                            .padding(.vertical, 3)
                            .background(
                                Capsule().fill(Color.white.opacity(0.05))
                            )
                    }
                }
                .padding(.top, 4)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(hex: "1a1f35").opacity(0.6))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .strokeBorder(Color.white.opacity(0.08), lineWidth: 1)
                )
        )
    }
}

#Preview {
    WorkCardView(work: WorksData.all[0])
        .padding()
        .background(Color(hex: "0a0e1a"))
}
