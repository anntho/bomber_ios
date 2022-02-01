import Foundation

class DashboardState: ObservableObject {
    @Published var hasActiveGame: Bool = false
    @Published var toggles: DashboardToggles = DashboardToggles(false, false)
    @Published var triggers: DashboardNavigationTriggers = DashboardNavigationTriggers(false, false)
    @Published var events: DashboardViewEvents = DashboardViewEvents()
    @Published var gamesPlayed: Int = 0
    @Published var wins: Int = 0
    @Published var losses: Int = 0
    @Published var genreId: Int = 0
}

struct DashboardNavigationTriggers: Codable {
    var newGame: Bool = false
    var activeGame: Bool = false

    init(_ newGame: Bool, _ activeGame: Bool) {
        self.newGame = newGame
        self.activeGame = activeGame
    }
}

struct DashboardToggles: Codable {
    var loading: Bool = false
    var searching: Bool = false

    init(_ loading: Bool, _ searching: Bool) {
        self.loading = loading
        self.searching = searching
    }
}

struct DashboardViewEvents: Codable {
    var dashboard: String = "users:dashboard"
    var search: String = "users:dashboard:games:search"
    var connected: String = "users:dashboard:games:connected"
    var cancel: String = "users:dashboard:games:cancel"
}
