import SwiftUI

struct WelcomeView: View {
    @State private var showContent = false

    var body: some View {
        ZStack {
            DS.Colors.bgPrimary.ignoresSafeArea()

            Circle()
                .fill(DS.Colors.accentIndigo.opacity(0.1))
                .frame(width: 300, height: 300)
                .blur(radius: 60)
                .offset(x: -80, y: -150)

            Circle()
                .fill(DS.Colors.accentPink.opacity(0.1))
                .frame(width: 200, height: 200)
                .blur(radius: 50)
                .offset(x: 100, y: 100)

            VStack(spacing: 0) {
                Spacer()

                Text("📖")
                    .font(.system(size: 64))
                    .padding(.bottom, DS.Spacing.xxl)

                Text("よむエモ")
                    .font(DS.Fonts.serifBold(48))
                    .foregroundStyle(DS.Gradients.brandTitle)
                    .padding(.bottom, DS.Spacing.md)

                Text("100年前の感情を、覗いてみよう。")
                    .font(DS.Fonts.body(17, weight: .light))
                    .foregroundColor(DS.Colors.textSecondary)
                    .padding(.bottom, DS.Spacing.xs)

                Text("純文学 × タップ読書 × バイブス解説")
                    .font(DS.Fonts.body(13))
                    .foregroundColor(DS.Colors.textSecondary.opacity(0.6))
                    .padding(.bottom, 48)

                NavigationLink(destination: HomeView()) {
                    Text("はじめる")
                        .font(DS.Fonts.body(18, weight: .medium))
                        .foregroundColor(.white)
                        .frame(width: 200, height: 56)
                        .background(DS.Colors.accentIndigo)
                        .clipShape(Capsule())
                        .shadow(color: DS.Colors.accentIndigo.opacity(0.4), radius: 20, y: 4)
                }

                Spacer()

                HStack(spacing: DS.Spacing.xxl) {
                    ForEach(["太宰治", "芥川龍之介", "夏目漱石", "宮沢賢治"], id: \.self) { name in
                        Text(name)
                            .font(DS.Fonts.body(11))
                            .foregroundColor(DS.Colors.textSecondary.opacity(0.4))
                    }
                }
                .padding(.bottom, 40)
            }
            .opacity(showContent ? 1 : 0)
            .offset(y: showContent ? 0 : 20)
        }
        .navigationBarHidden(true)
        .onAppear {
            withAnimation(.easeOut(duration: 0.8)) {
                showContent = true
            }
        }
    }
}

#Preview {
    NavigationStack {
        WelcomeView()
    }
}
