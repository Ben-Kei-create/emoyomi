import SwiftUI

@main
struct YomuEmoApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                WelcomeView()
                    .navigationDestination(for: AppRoute.self) { route in
                        route.destination
                    }
            }
            .preferredColorScheme(.dark)
        }
    }
}
