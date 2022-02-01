import Foundation

class LandingState: ObservableObject {
    @Published var toggles: LandingToggles = LandingToggles()
    @Published var rootIsActive: Bool = false
}

struct LandingToggles: Codable {
    var login: Bool = false
    var signup: Bool = false
    var toolbarSettingsIcon: Bool = false
}
