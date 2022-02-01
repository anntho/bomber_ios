import SwiftUI

struct ActiveGameButton: View {
    @EnvironmentObject var state: DashboardState
    @EnvironmentObject var service: Service

    func joinActiveGame() -> Void {
        if (state.hasActiveGame && !state.toggles.loading && !state.toggles.searching) {
            state.triggers.activeGame = true
        }
    }

    var body: some View {
        if state.hasActiveGame {
            NavigationLink(destination: PeerGameView(), isActive: $state.triggers.activeGame) {
                Button("Resume Game", action: joinActiveGame)
                    .buttonStyle(GreenButtonStyle())
                    .allowsHitTesting(state.toggles.searching ? false : true)
                    .disabled(state.toggles.searching ? true : false)
            }
            .isDetailLink(false)
        }

    }
}

struct CardGroupBoxStyle: GroupBoxStyle {
    func makeBody(configuration: Configuration) -> some View {
        VStack(alignment: .leading) {
            configuration.label
            configuration.content
        }
        .frame(maxWidth: 300, alignment: .leading)
        .padding()
        .background(Color(UIColor.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
    }
}

struct GameHistoryWidget: View {
    @EnvironmentObject var state: DashboardState
    @EnvironmentObject var rootState: RootState

    private var gridItemLayout = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        VStack(alignment: .leading) {
            VStack {
                NavigationLink(destination: SettingsView()) {
                    Image(systemName: "arrow.up.right.square.fill")
                        .font(.system(size: 25))
                        .foregroundColor(.purple)
                }
                .isDetailLink(false)
            }
            .padding(.bottom, 10)

            LazyVGrid(columns: gridItemLayout, spacing: 5) {
                Text("games played")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.gray)
                Text(String(state.gamesPlayed))
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .font(.headline)
                    .foregroundColor(.accentColor)

                Text("wins")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.gray)
                Text(String(state.wins))
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .font(.headline)
                    .foregroundColor(.green)

                Text("loses")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.gray)
                Text(String(state.losses))
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .font(.headline)
                    .foregroundColor(.red)
            }
        }
        .frame(maxWidth: 300)
        .padding()
        .background(Color(UIColor.systemGray6))
        .foregroundColor(.white)
        .cornerRadius(8)
    }
}

struct GameModeWidget: View {
    @EnvironmentObject var state: DashboardState
    @EnvironmentObject var rootState: RootState

    private var gridItemLayout = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        VStack(alignment: .leading) {

            NavigationLink(destination: GameModeView().environmentObject(state)) {
                Text("Play").foregroundColor(.accentColor)
            }
            .isDetailLink(false)

        }
        .frame(maxWidth: 300)
        .padding()
        .background(Color(UIColor.systemGray6))
        .foregroundColor(.white)
        .cornerRadius(8)
    }
}

