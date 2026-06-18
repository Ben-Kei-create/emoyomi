import SwiftUI

@main
struct YomuEmoApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                WelcomeView()
            }
            .preferredColorScheme(.dark)
        }
    }
}
