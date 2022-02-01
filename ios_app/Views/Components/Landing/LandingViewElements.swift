import SwiftUI

struct LandingMainView: View {
    @EnvironmentObject var state: LandingState
    @EnvironmentObject var user: User
    @EnvironmentObject var service: Service
    @EnvironmentObject var rootState: RootState

    var body: some View {
        ZStack {
            VStack {
                Spacer()

                HStack {
                    Image(systemName: "play.fill")
                        .renderingMode(.template)
                        .foregroundColor(.blue)
                    Text("moviebomber")
                        .font(.headline)
                        .foregroundColor(Color(.systemGray))
                }

                Spacer()

                NavigationLink(destination: SignupView(), isActive: $state.toggles.signup) {
                    Button("Get Started", action: { state.toggles.signup = true })
                        .buttonStyle(PrimaryButtonStyle())
                }
                .isDetailLink(false)

                NavigationLink(destination: LoginView(), isActive: $state.toggles.login) {
                    Button("Login", action: { state.toggles.login = true })
                        .buttonStyle(TransparentButtonStyle())
                }
                .isDetailLink(false)
            }
        }
    }
}
