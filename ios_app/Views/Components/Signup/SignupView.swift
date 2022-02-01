import SwiftUI

struct SignupView: View {
    @StateObject var state = SignupViewState()
    @EnvironmentObject var user: User
    @EnvironmentObject var service: Service
    @EnvironmentObject var rootState: RootState

    func signup() -> Void {
        let data: [String: Any] = [
            "username": state.inputs.username,
            "email": state.inputs.email,
            "password": state.inputs.password
        ]

        service.socket.emit(state.events.signup, data)
        service.socket.on(state.events.signup) { (data, ack) in
            if let data = data[0] as? Int {
                if data == 1 {
                    state.triggers.isActive = true
                    state.inputs.signupError = false
                } else {
                    state.inputs.signupError = true
                }
            }
        }
    }

    var body: some View {
        VStack {
            NavigationLink(destination: LandingView(), isActive: $state.triggers.isActive) {
                EmptyView()
            }
            .isDetailLink(false)

            Form {
                Section(header: Text("Create your account")) {
                    TextField("Username", text: $state.inputs.username).autocapitalization(.none)
                    TextField("Email", text: $state.inputs.email).autocapitalization(.none)
                    SecureField("Password", text: $state.inputs.password)
                    Button("Signup", action: signup)
                    if state.inputs.signupError {
                        Text("User already exists").foregroundColor(.red)
                    }
                }
            }
        }
        .onDisappear() {
            service.socket.off(state.events.signup)
        }
    }
}
