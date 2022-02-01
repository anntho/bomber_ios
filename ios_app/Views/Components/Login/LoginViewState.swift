import Foundation

class LoginViewState: ObservableObject {
    @Published var triggers: LoginNavigationTriggers = LoginNavigationTriggers()
    @Published var inputs: LoginInputs = LoginInputs()
    @Published var toggles: LoginToggles = LoginToggles()
    @Published var events: LoginViewEvents = LoginViewEvents()
}

struct LoginToggles: Codable {
    var isLoading: Bool = false
}

struct LoginNavigationTriggers: Codable {
    var isActive: Bool = false
}

struct LoginInputs: Codable {
    var identifier: String = ""
    var password: String = ""
    var loginError: Bool = false
}

struct LoginViewEvents: Codable {
    var login: String = "users:login"
}
