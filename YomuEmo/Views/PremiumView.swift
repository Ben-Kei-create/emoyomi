import SwiftUI

struct PremiumView: View {
    @State private var store = StoreManager.shared
    @State private var purchased = false
    @Environment(\.dismiss) private var dismiss

    private let features: [(icon: String, title: String, desc: String)] = [
        ("📚", "全作品アクセス", "すべての作品が読み放題"),
        ("💬", "全バイブス解説", "すべてのシーンの感情解説"),
        ("📊", "感情メーター", "各シーンの感情値を可視化"),
        ("🖋️", "文豪プロフィール", "全文豪の詳細プロフィール"),
        ("🎨", "テーマ変更", "背景や配色をカスタマイズ"),
        ("⭐", "お気に入り", "好きな作品を保存"),
    ]

    var body: some View {
        ZStack {
            DS.Colors.bgPrimary.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    backButton
                    titleSection
                    featuresGrid
                    purchaseSection
                }
            }
        }
        .navigationBarHidden(true)
    }

    private var backButton: some View {
        HStack {
            Button(action: { dismiss() }) {
                Text("← 戻る")
                    .font(DS.Fonts.body(14))
                    .foregroundColor(DS.Colors.textSecondary)
            }
            Spacer()
        }
        .padding(.horizontal, DS.Spacing.xl)
        .padding(.top, DS.Spacing.md)
        .padding(.bottom, DS.Spacing.lg)
    }

    private var titleSection: some View {
        VStack(spacing: DS.Spacing.md) {
            Text("✦ Premium")
                .font(DS.Fonts.small().weight(.medium))
                .foregroundColor(DS.Colors.accentWarm)
                .padding(.horizontal, DS.Spacing.lg)
                .padding(.vertical, 6)
                .background(
                    Capsule().fill(DS.Colors.accentWarm.opacity(0.1))
                )

            VStack(spacing: DS.Spacing.xs) {
                Text("すべての文学体験を")
                    .font(DS.Fonts.serifBold(26))
                    .foregroundColor(DS.Colors.textPrimary)

                Text("解放する")
                    .font(DS.Fonts.serifBold(26))
                    .foregroundStyle(DS.Gradients.brandTitle)
            }

            Text("買い切りで、広告なし。ずっと使える。")
                .font(DS.Fonts.body(14))
                .foregroundColor(DS.Colors.textSecondary)
        }
        .padding(.bottom, DS.Spacing.xxxl)
    }

    private var featuresGrid: some View {
        LazyVGrid(columns: [
            GridItem(.flexible(), spacing: DS.Spacing.md),
            GridItem(.flexible(), spacing: DS.Spacing.md),
        ], spacing: DS.Spacing.md) {
            ForEach(Array(features.enumerated()), id: \.offset) { _, feature in
                VStack(alignment: .leading, spacing: DS.Spacing.sm) {
                    Text(feature.icon)
                        .font(.system(size: 28))

                    Text(feature.title)
                        .font(DS.Fonts.body(14, weight: .medium))
                        .foregroundColor(DS.Colors.textPrimary)

                    Text(feature.desc)
                        .font(DS.Fonts.caption())
                        .foregroundColor(DS.Colors.textSecondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(DS.Spacing.lg)
                .glassCard()
            }
        }
        .padding(.horizontal, DS.Spacing.xl)
        .padding(.bottom, DS.Spacing.xxxl)
    }

    private var purchaseSection: some View {
        VStack(spacing: DS.Spacing.md) {
            if purchased || store.isPremium {
                VStack(spacing: DS.Spacing.sm) {
                    Text("🎉")
                        .font(.system(size: 48))
                    Text("Premium有効")
                        .font(DS.Fonts.body(18, weight: .medium))
                        .foregroundColor(DS.Colors.textPrimary)
                    Text("すべての機能が使えます")
                        .font(DS.Fonts.body(14))
                        .foregroundColor(DS.Colors.textSecondary)
                }
                .frame(maxWidth: .infinity)
                .padding(DS.Spacing.xxl)
                .glassCard()
            } else {
                PrimaryButton(title: "¥980 で購入（買い切り）") {
                    store.isPremium = true
                    purchased = true
                }

                Text("一度の購入で、すべての機能がずっと使えます。\n読書中の広告は表示されません。")
                    .font(DS.Fonts.caption())
                    .foregroundColor(DS.Colors.textSecondary.opacity(0.5))
                    .multilineTextAlignment(.center)
            }
        }
        .padding(.horizontal, DS.Spacing.xl)
        .padding(.bottom, 40)
    }
}

#Preview {
    NavigationStack {
        PremiumView()
    }
}
