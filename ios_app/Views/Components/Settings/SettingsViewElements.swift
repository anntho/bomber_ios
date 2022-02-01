import SwiftUI

struct SettingsSignOutButton: View {
    @EnvironmentObject var user: User
    @EnvironmentObject var service: Service
    @EnvironmentObject var rootState: RootState

    @Binding var isActive: Bool

    private let defaults = UserDefaults.standard

    func signout() {
        isActive = true
        user.isSignedOut = true
        service.socket.emit("logout", UserDefaults.standard.integer(forKey: "userId"))

        defaults.set(false, forKey: "isUserLoggedIn")
        defaults.set(nil, forKey: "userId")
        defaults.synchronize()

        user.userId = 0
        user.username = ""
        user.email = ""
        
        rootState.isLoggedIn = false
    }

    var body: some View {
        VStack {
            Spacer()

            Button("Signout", action: signout)
                .buttonStyle(PrimaryButtonStyle())

            .onDisappear() {
                service.socket.off("logout")
            }
        }
    }
}
