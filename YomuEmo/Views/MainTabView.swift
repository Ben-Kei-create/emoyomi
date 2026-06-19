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

            CollectionView()
                .tabItem {
                    Image(systemName: "bookmark.fill")
                    Text("ことば帳")
                }

            ProfileView()
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("マイページ")
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
