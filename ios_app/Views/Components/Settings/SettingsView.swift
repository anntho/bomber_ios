import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var user: User
    @EnvironmentObject var service: Service
    @EnvironmentObject var rootState: RootState

    @State private var isActive = false

    var body: some View {
        ZStack {
            SettingsSignOutButton(isActive: $isActive)
        }
    }
}
