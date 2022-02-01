import SwiftUI
import Foundation

@main
struct ios_appApp: App {
    @Environment(\.scenePhase) var scenePhase

    @StateObject var user = User()
    @StateObject var service = Service()
    @StateObject var rootState = RootState()
    
    private let defaults = UserDefaults.standard

    var body: some Scene {
        WindowGroup {
            NavigationView {
                if rootState.isLoggedIn {
                    DashboardView()
                } else {
                    LandingView()
                }
            }
            .environmentObject(service)
            .environmentObject(user)
            .environmentObject(rootState)
            .navigationViewStyle(StackNavigationViewStyle())
            .onAppear() {
                let isLoggedIn = defaults.bool(forKey: "isUserLoggedIn")
                if isLoggedIn {
                    rootState.isLoggedIn = true
                }
                else {
                    rootState.isLoggedIn = false
                }
            }
        }
//        .onChange(of: scenePhase) { phase in
//            switch phase {
//            case .active:
//                print("[scene] active")
//            case .inactive:
//                print("[scene] inactive")
//            case .background:
//                print("[scene] background")
//            @unknown default:
//                print("[scene] something new by apple")
//            }
//        }
    }
}

class RootState: ObservableObject {
    @Published var isLoggedIn: Bool = false
}

class User: ObservableObject {
    @Published var userId: Int = 0
    @Published var username: String = ""
    @Published var email: String = ""
    @Published var rank: String = ""
    @Published var elo: Int = 0
    @Published var isLoggedIn: Bool = false
    @Published var isSignedOut: Bool = false
    @Published var rootIsActive: Bool = false

    func setUser(_ obj: [String: Any]) -> Void {
        userId = obj["userId"] as? Int ?? 0
        username = obj["username"] as? String ?? ""
        email = obj["email"] as? String ?? ""
        rank = obj["rank"] as? String ?? ""
        elo = obj["elo"] as? Int ?? 0
    }
}
