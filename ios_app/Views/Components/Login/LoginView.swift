import SwiftUI

struct LoginView: View {
    @StateObject var state = LoginViewState()

    @EnvironmentObject var user: User
    @EnvironmentObject var service: Service
    @EnvironmentObject var rootState: RootState

    func setUserIsLoggedIn(_ userId: Int, _ username: String, _ email: String) -> Void {
        UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
        UserDefaults.standard.set(userId, forKey: "userId")
        UserDefaults.standard.synchronize()
    
        rootState.isLoggedIn = true

        user.userId = userId
        user.username = username
        user.email = email
    }

    func login() -> Void {
        withAnimation {
            state.toggles.isLoading = true
        }
        
        registerListeners()
        
        let data: [String: Any] = [
            "identifier": state.inputs.identifier,
            "password": state.inputs.password
        ]

        service.socket.emit(state.events.login, data)
    }
    
    func registerListeners() -> Void {
        service.socket.on(state.events.login) { data, ack in
            let obj = service.decodeData(data)
            if !obj.isEmpty {
                let userId = obj["userId"] as! Int
                let username = obj["username"] as! String
                let email = obj["email"] as! String

                setUserIsLoggedIn(userId, username, email)

                state.toggles.isLoading = false
                rootState.isLoggedIn = true
            } else {
                state.toggles.isLoading = false
                state.inputs.loginError = true
            }
        }
    }

    var body: some View {
        ZStack {
            Loader(isLoading: $state.toggles.isLoading)

            VStack {
                Form {
                    Section(header: Text("Login")) {
                        TextField("Username or email", text: $state.inputs.identifier).autocapitalization(.none)
                        SecureField("Password", text: $state.inputs.password).autocapitalization(.none)
                        Button("Login", action: login)
                        if state.inputs.loginError {
                            Text("Credentials are incorrect").foregroundColor(.red)
                        }
                    }
                }
            }
        }
        .onDisappear() {
            service.socket.off(state.events.login)
        }
    }
}
