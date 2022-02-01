import Foundation

class SignupViewState: ObservableObject {
    @Published var triggers: SignupNavigationTriggers = SignupNavigationTriggers()
    @Published var inputs: SignupInputs = SignupInputs()
    @Published var events: SignupViewEvents = SignupViewEvents()
}

struct SignupNavigationTriggers: Codable {
    var isActive: Bool = false
}

struct SignupInputs: Codable {
    var username: String = ""
    var email: String = ""
    var password: String = ""
    var signupError: Bool = false
}

struct SignupViewEvents: Codable {
    var signup: String = "users:signup"
}
