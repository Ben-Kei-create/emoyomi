import SwiftUI

enum AppRoute: Hashable {
    case home
    case worksList
    case reading(workId: String)
    case completion(workId: String)
    case authorProfile(authorId: String)
    case premium
    case diagnosis
    case favorites
}

extension AppRoute {
    @ViewBuilder
    var destination: some View {
        switch self {
        case .home:
            HomeView()
        case .worksList:
            WorksListView()
        case .reading(let workId):
            if let work = WorksData.find(by: workId) {
                ReadingView(work: work)
            }
        case .completion(let workId):
            if let work = WorksData.find(by: workId) {
                CompletionView(work: work)
            }
        case .authorProfile(let authorId):
            if let author = AuthorsData.find(by: authorId) {
                AuthorProfileView(author: author)
            }
        case .premium:
            PremiumView()
        case .diagnosis:
            EmotionDiagnosisView()
        case .favorites:
            FavoritesView()
        }
    }
}
