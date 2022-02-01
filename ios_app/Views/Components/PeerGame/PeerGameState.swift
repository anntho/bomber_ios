import Foundation

class Game: ObservableObject {
    @Published var sid: String = ""
    @Published var status: String = ""
    @Published var ids: [String] = []
    @Published var index: Int = 0
    @Published var currentMovieId: String = ""
    @Published var gameOver: Bool = false
    
    @Published var userElo: Int = 0
    @Published var opponentElo: Int = 0
    @Published var win: Bool = false
    @Published var rank: String = ""
    @Published var timeout: Bool = false

    @Published var labelText: String = ""

    @Published var userId: Int = 0
    @Published var username: String = ""
    @Published var score: Int = 0

    @Published var opponentUserId: Int = 0
    @Published var opponentUsername: String = ""
    @Published var opponentScore: Int = 0

    @Published var movies = [MovieStruct]()
    @Published var questionLabelText = ""
    @Published var currentMovie = MovieStruct(altId: "", correct: [], incorrect: [], title: "", releaseYear: "")
    @Published var choices = [ChoiceStruct]()
    @Published var buttons = [
        GameButton(text: "loading..", action: {}, isCorrect: false),
        GameButton(text: "loading..", action: {}, isCorrect: false),
        GameButton(text: "loading..", action: {}, isCorrect: false),
        GameButton(text: "loading..", action: {}, isCorrect: false)
    ]
    
    func setGameData(_ obj: [String: Any]) -> Void {
        sid = obj["sid"] as! String
        status = obj["status"] as! String
        index = obj["index"] as! Int
        currentMovieId = obj["id"] as! String

        userId = obj["userId"] as! Int
        username = obj["username"] as! String
        score = obj["score"] as! Int
        opponentUserId = obj["opponentUserId"] as! Int
        opponentUsername = obj["opponentUsername"] as! String
        opponentScore = obj["opponentScore"] as! Int

        for i in obj["ids"] as! [String] {
            ids.append(i)
        }
    }

    func setChoices() -> Void {
        for correctChoice in currentMovie.correct {
            choices.append(ChoiceStruct(text: correctChoice!, isCorrect: true))
        }

        for incorrectChoice in currentMovie.incorrect {
            choices.append(ChoiceStruct(text: incorrectChoice!, isCorrect: false))
        }

        choices.shuffle()
    }
    
    func setQuestionLabel() -> Void {
        questionLabelText = "Which of the following actors stared in the film \(currentMovie.title) (\(currentMovie.releaseYear))?"
    }
    
    func setCurrentMovie() -> Void {
        // make the list go in the right synced order
        // currentMovie = movies[currentMovieId]
        if let movie = movies.first(where: {$0.altId == currentMovieId}) {
            currentMovie = movie
        } else {
           // item could not be found
        }
        currentMovie.correct = Array(currentMovie.correct.prefix(1))
        currentMovie.incorrect = Array(currentMovie.incorrect.prefix(3))
    }

    func setButtons(_ service: Service) -> Void {
        for (i, choice) in choices.enumerated() {
            buttons[i].text = choice.text
            buttons[i].isCorrect = choice.isCorrect
            buttons[i].disabled = false
            buttons[i].highlight = false
            buttons[i].action = { self.checkUserChoice(i, choice.isCorrect, service) }
        }
    }
    
    func checkUserChoice(_ buttonIndex: Int, _ isCorrect: Bool, _ service: Service) -> Void {
        if buttons[buttonIndex].disabled == true {
            return
        }

        deactivateButtons(buttonIndex)

        let event: String = "games:guess"
        let data: [String: Any] = [
            "sid": sid,
            "userId": userId,
            "correct": isCorrect,
            "id": currentMovie.altId,
            "timeout": false
        ]

        service.socket.emit(event, data)
    }

    func deactivateButtons(_ buttonIndex: Int = -1) -> Void {
        for (i, _) in buttons.enumerated() {
            buttons[i].disabled = true
        }

        for (i, _) in buttons.enumerated() {
            if (buttonIndex == i || buttons[i].isCorrect) {
                buttons[i].highlight = true
            }
        }
    }

    func loadNext(_ service: Service) -> Void {
        if (index == movies.count) {
            return
        }

        setCurrentMovie()
        setChoices()
        setButtons(service)
        setQuestionLabel()
        choices = []
        timeout = false
    }
}

struct MovieStruct: Codable {
    let altId: String
    var correct: [String?]
    var incorrect: [String?]
    let title: String
    let releaseYear: String
}

struct ChoiceStruct: Codable {
    var text: String
    var isCorrect: Bool
}

struct PeerGameViewEvents: Codable {
    var guess: String = "games:guess"
    var load: String = "games:load"
    var win: String = "games:guess:win"
    var lose: String = "games:guess:lose"
    var advance: String = "games:advance"
    var timeout: String = "games:timeout"
    var gameover: String = "games:gameover"
    var resign: String = "games:resign"
}
