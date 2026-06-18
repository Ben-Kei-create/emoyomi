import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Image(systemName: "book.fill")
                    Text("ホーム")
                }

            WorksListView()
                .tabItem {
                    Image(systemName: "text.book.closed.fill")
                    Text("作品")
                }

            FavoritesView()
                .tabItem {
                    Image(systemName: "bookmark.fill")
                    Text("お気に入り")
                }

            PremiumView()
                .tabItem {
                    Image(systemName: "star.fill")
                    Text("Premium")
                }
        }
        .tint(DS.Colors.accentIndigo)
    }
}

#Preview {
    NavigationStack {
        MainTabView()
    }
}
