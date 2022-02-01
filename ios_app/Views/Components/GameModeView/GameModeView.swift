import SwiftUI

struct GameModeView: View {
    @EnvironmentObject var state: DashboardState
    @EnvironmentObject var rootState: RootState

    var body: some View {
        VStack() {
            Loader(isLoading: $state.toggles.loading)

            NewGameButton(text: "Popular", id: 1)

            Spacer()

            VStack {
                CancelGameButton().environmentObject(state)
            }
        }
    }
}


