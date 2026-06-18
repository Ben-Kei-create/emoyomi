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
            Color(hex: "0a0e1a").ignoresSafeArea()

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
                    .font(.system(size: 14))
                    .foregroundColor(Color(hex: "9ca3af"))
            }
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.top, 12)
        .padding(.bottom, 16)
    }

    private var titleSection: some View {
        VStack(spacing: 12) {
            Text("✦ Premium")
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(Color(hex: "f59e0b"))
                .padding(.horizontal, 16)
                .padding(.vertical, 6)
                .background(
                    Capsule().fill(Color(hex: "f59e0b").opacity(0.1))
                )

            VStack(spacing: 4) {
                Text("すべての文学体験を")
                    .font(.custom("HiraginoSans-W7", size: 26))
                    .foregroundColor(Color(hex: "e8e2d6"))

                Text("解放する")
                    .font(.custom("HiraginoSans-W7", size: 26))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [Color(hex: "818cf8"), Color(hex: "ec4899")],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
            }

            Text("買い切りで、広告なし。ずっと使える。")
                .font(.system(size: 14))
                .foregroundColor(Color(hex: "9ca3af"))
        }
        .padding(.bottom, 32)
    }

    private var featuresGrid: some View {
        LazyVGrid(columns: [
            GridItem(.flexible(), spacing: 12),
            GridItem(.flexible(), spacing: 12),
        ], spacing: 12) {
            ForEach(Array(features.enumerated()), id: \.offset) { _, feature in
                VStack(alignment: .leading, spacing: 8) {
                    Text(feature.icon)
                        .font(.system(size: 28))

                    Text(feature.title)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(Color(hex: "e8e2d6"))

                    Text(feature.desc)
                        .font(.system(size: 10))
                        .foregroundColor(Color(hex: "9ca3af"))
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
        .padding(.horizontal, 20)
        .padding(.bottom, 32)
    }

    private var purchaseSection: some View {
        VStack(spacing: 12) {
            if purchased || store.isPremium {
                VStack(spacing: 8) {
                    Text("🎉")
                        .font(.system(size: 48))
                    Text("Premium有効")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(Color(hex: "e8e2d6"))
                    Text("すべての機能が使えます")
                        .font(.system(size: 14))
                        .foregroundColor(Color(hex: "9ca3af"))
                }
                .frame(maxWidth: .infinity)
                .padding(24)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color(hex: "1a1f35").opacity(0.6))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .strokeBorder(Color.white.opacity(0.08), lineWidth: 1)
                        )
                )
            } else {
                Button(action: {
                    store.isPremium = true
                    purchased = true
                }) {
                    Text("¥980 で購入（買い切り）")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(
                            Capsule()
                                .fill(Color(hex: "6366f1"))
                                .shadow(color: Color(hex: "6366f1").opacity(0.4), radius: 16, y: 4)
                        )
                }

                Text("一度の購入で、すべての機能がずっと使えます。\n読書中の広告は表示されません。")
                    .font(.system(size: 10))
                    .foregroundColor(Color(hex: "9ca3af").opacity(0.5))
                    .multilineTextAlignment(.center)
            }
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 40)
    }
}

#Preview {
    NavigationStack {
        PremiumView()
    }
}
