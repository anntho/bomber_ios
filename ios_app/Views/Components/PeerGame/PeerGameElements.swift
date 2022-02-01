import SwiftUI

struct QuestionLabel: View {
    var text: String

    var body: some View {
        VStack {
            Label(text, systemImage: "questionmark.circle.fill").minimumScaleFactor(0.01)
        }
        .padding()
        .frame(maxWidth: 320)
        .background(Color(UIColor.systemGray6))
        .foregroundColor(.gray)
        .cornerRadius(8)
    }
}

struct GameButton: View {
    var text: String
    var action: () -> Void
    var isCorrect: Bool
    var highlight: Bool = false
    var disabled: Bool = false

    var body: some View {
        Button(action: action) {
            Text(text)
                .padding()
                .frame(
                    minWidth: 0,
                    idealWidth: 320,
                    maxWidth: 320,
                    minHeight: 0,
                    idealHeight: 60,
                    maxHeight: 60,
                    alignment: .center
                )
                .font(.system(size: 15, weight: .bold))
                .foregroundColor(Color.white)
                .background(highlight ? (isCorrect ? Color.green : Color.red) : disabled ? Color.gray : Color.accentColor)
                .cornerRadius(8)
        }
    }
}

struct StatsView: View {
    @EnvironmentObject var game: Game
    
    private var gridItemLayout = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        VStack {
            LazyVGrid(columns: gridItemLayout, spacing: 5) {
                Text("turns")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(.gray)
                Text(String(game.index + 1))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.headline)
                    .foregroundColor(.accentColor)

                Text(String(game.username))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(.gray)
                Text(String(game.score))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.headline)
                    .foregroundColor(.green)

                Text(String(game.opponentUsername))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(.gray)
                Text(String(game.opponentScore))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.headline)
                    .foregroundColor(.red)
            }
        }
        .padding()
        .frame(maxWidth: 320)
        .background(Color(UIColor.systemGray6))
        .foregroundColor(.white)
        .cornerRadius(8)
    }
}

struct GameOverWidget: View {
    @EnvironmentObject var game: Game

    private var gridItemLayout = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        VStack {
            Text(game.win ? "You Won!" : "You lost")
                .padding()
                .frame(
                    minWidth: 0,
                    idealWidth: 320,
                    maxWidth: 320,
                    minHeight: 0,
                    idealHeight: 60,
                    maxHeight: 60,
                    alignment: .center
                )
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(game.win ? .accentColor : .red)
                .background(Color(UIColor.systemGray6))
                .cornerRadius(8)
        }
        LazyVGrid(columns: gridItemLayout, spacing: 5) {
            Text(String(game.username))
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.system(size: 17))
            VStack {
                Text(String(game.userElo))
                    .font(.headline)
                + Text(String(game.win ? " (+7)" : " (-7)"))
                    .foregroundColor(game.win ? .green : .red)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            Text(String(game.opponentUsername))
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.system(size: 17))
            VStack {
                Text(String(game.opponentElo))
                    .font(.headline)
                + Text(String(game.win ? " (-7)" : " (+7)"))
                    .foregroundColor(game.win ? .red : .green)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            Text("rank")
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.system(size: 17))
            Text(String(game.rank))
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.headline)
        }
        .padding()
        .frame(maxWidth: 320)
        .background(Color(UIColor.systemGray6))
        .foregroundColor(.gray)
        .cornerRadius(8)
    }
}

struct BackToDashboardButton: View {
    @EnvironmentObject var rootState: RootState
    @State var isActive: Bool = false

    func setIsActive() -> Void {
        isActive = true
    }

    var body: some View {
        VStack {
            NavigationLink(destination: DashboardView(), isActive: $isActive) {
                Button("Return to Dashboard", action: setIsActive).buttonStyle(PrimaryButtonStyle())
            }
            .isDetailLink(false)
        }
        .padding(.bottom, 60.0)
    }
}

struct ResignButton: View {
    @EnvironmentObject var service: Service
    @EnvironmentObject var game: Game
    
    @State private var events: PeerGameViewEvents = PeerGameViewEvents()
    
    func resign() -> Void {
        let data: [String: Any] = ["sid": game.sid, "userId": game.userId]
        service.socket.emit(events.resign, data)
    }

    var body: some View {
        VStack {
            NavigationLink(destination: DashboardView()) {
                Button("Resign", action: resign)
                    .buttonStyle(RedButtonStyle())
            }
            .isDetailLink(false)
        }
    }
}
