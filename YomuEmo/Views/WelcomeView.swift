import SwiftUI

struct WelcomeView: View {
    @State private var showContent = false

    var body: some View {
        ZStack {
            Color(hex: "0a0e1a").ignoresSafeArea()

            Circle()
                .fill(Color(hex: "6366f1").opacity(0.1))
                .frame(width: 300, height: 300)
                .blur(radius: 60)
                .offset(x: -80, y: -150)

            Circle()
                .fill(Color(hex: "ec4899").opacity(0.1))
                .frame(width: 200, height: 200)
                .blur(radius: 50)
                .offset(x: 100, y: 100)

            VStack(spacing: 0) {
                Spacer()

                Text("📖")
                    .font(.system(size: 64))
                    .padding(.bottom, 24)

                Text("よむエモ")
                    .font(.custom("HiraginoSans-W7", size: 48))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [Color(hex: "818cf8"), Color(hex: "ec4899")],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .padding(.bottom, 12)

                Text("100年前の感情を、覗いてみよう。")
                    .font(.system(size: 17, weight: .light))
                    .foregroundColor(Color(hex: "9ca3af"))
                    .padding(.bottom, 4)

                Text("純文学 × タップ読書 × バイブス解説")
                    .font(.system(size: 13))
                    .foregroundColor(Color(hex: "9ca3af").opacity(0.6))
                    .padding(.bottom, 48)

                NavigationLink(destination: HomeView()) {
                    Text("はじめる")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.white)
                        .frame(width: 200, height: 56)
                        .background(Color(hex: "6366f1"))
                        .clipShape(Capsule())
                        .shadow(color: Color(hex: "6366f1").opacity(0.4), radius: 20, y: 4)
                }

                Spacer()

                HStack(spacing: 24) {
                    ForEach(["太宰治", "芥川龍之介", "夏目漱石", "宮沢賢治"], id: \.self) { name in
                        Text(name)
                            .font(.system(size: 11))
                            .foregroundColor(Color(hex: "9ca3af").opacity(0.4))
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
