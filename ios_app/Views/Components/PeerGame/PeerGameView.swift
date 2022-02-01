import SwiftUI
import Foundation

struct PeerGameView: View {
    @StateObject var game = Game()

    @EnvironmentObject var user: User
    @EnvironmentObject var service: Service

    @State private var events: PeerGameViewEvents = PeerGameViewEvents()
    @State private var firstAppear = true

    func alertView (_ title: String) {
        let alert = UIAlertController(
            title: "",
            message: "",
            preferredStyle: .alert
        )

        alert.title = title

        let cancel = UIAlertAction(title: "OK", style: .destructive) { (_) in }

        alert.addAction(cancel)

        UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true, completion: {})
    }

    func parseMovies() -> [MovieStruct] {
        let url = Bundle.main.url(forResource: "movies", withExtension: "json")!
        let data = try! Data(contentsOf: url)
        let movies = try! JSONDecoder().decode([MovieStruct].self, from: data)
        return movies
    }

    func load(_ completion: @escaping () -> Void) {
        if !firstAppear { return }

        firstAppear = false
        game.movies = parseMovies()

        registerListeners()

        let data: [String: Any] = ["userId": UserDefaults.standard.integer(forKey: "userId")]
        service.socket.emit(events.load, data)
        service.socket.on(events.load) { data, ack in
            let obj = service.decodeData(data)
            if !obj.isEmpty {
                game.setGameData(obj)
                completion()
            }
        }
    }

    func registerListeners() -> Void {
        service.socket.on(events.gameover) { data, ack in
            let obj = service.decodeData(data)
            if !obj.isEmpty {
                let userScore = obj["userScore"] as! Int
                let opponentScore = obj["opponentScore"] as! Int
                let win = obj["win"] as! Bool
                let userElo = obj["userElo"] as! Int
                let opponentElo = obj["opponentElo"] as! Int
                let rank = obj["rank"] as! String

                game.score = userScore
                game.opponentScore = opponentScore
                game.win = win
                game.userElo = userElo
                game.opponentElo = opponentElo
                game.rank = rank
                game.gameOver = true
            }
        }
        service.socket.on(events.advance) { data, ack in
            let obj = service.decodeData(data)
            if !obj.isEmpty {
                let index = obj["index"] as! Int
                let bothWrong = obj["bothWrong"] as! Bool
                let userScore = obj["userScore"] as! Int
                let opponentScore = obj["opponentScore"] as! Int
                let timeout = obj["timeout"] as! Bool
                let win = obj["win"] as! Bool
                let id = obj["id"] as! String

                if timeout {
                    alertView("TIMES UP")
                }
                else if bothWrong {
                    alertView("DOUBLE FAIL")
                }
                else if win {
                    alertView("YOU WIN")
                }
                else {
                    alertView("YOU LOSE")
                }

                game.index = index
                game.currentMovieId = id
                game.score = userScore
                game.opponentScore = opponentScore
                game.loadNext(service)
            }
        }
    }

    var body: some View {
        ZStack {
            VStack {
                if !game.gameOver {
                    QuestionLabel(text: game.questionLabelText)
                }

                if !game.gameOver {
                    game.buttons[0]
                    game.buttons[1]
                    game.buttons[2]
                    game.buttons[3]
                } else {
                    GameOverWidget().environmentObject(game)
                }

                StatsView().environmentObject(game)
                
                if !game.gameOver {
                    ResignButton().environmentObject(game)
                }
                
                if game.gameOver {
                    BackToDashboardButton()
                }
            }
            .onAppear {
                load() { () -> () in
                    game.loadNext(service)
                }
            }
            .onDisappear() {
                service.socket.off(events.guess)
                service.socket.off(events.load)
                service.socket.off(events.win)
                service.socket.off(events.lose)
                service.socket.off(events.advance)
                service.socket.off(events.timeout)
                service.socket.off(events.gameover)
                service.socket.off(events.resign)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

