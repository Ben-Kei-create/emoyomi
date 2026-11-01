import SwiftUI
import GoogleMobileAds
import AppTrackingTransparency

@main
struct YomuEmoApp: App {
    init() {
        MobileAds.shared.start(completionHandler: nil)
    }

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                WelcomeView()
                    .navigationDestination(for: AppRoute.self) { route in
                        route.destination
                    }
            }
            .preferredColorScheme(.dark)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    ATTrackingManager.requestTrackingAuthorization { _ in }
                }
            }
        }
    }
}
