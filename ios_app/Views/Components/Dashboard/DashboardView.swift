import SwiftUI

struct DashboardView: View {
    @StateObject var state = DashboardState()
    @EnvironmentObject var user: User
    @EnvironmentObject var service: Service
    @EnvironmentObject var rootState: RootState

    @State var hasAppeared: Bool = false
    
    func cancel() -> Void {
        let data: [String: Int] = ["userId": UserDefaults.standard.integer(forKey: "userId")]
        service.socket.emit(state.events.cancel, data)
        service.socket.on(state.events.cancel) { data, ack in
            state.toggles.searching = false
            // might need loading = false
        }
    }

    func loadDashboardView() -> Void {
        if hasAppeared {
            return
        }

        cancel()

        hasAppeared = true

        state.toggles.loading = true

        if service.connected {
            loadUserData()
            return
        }

        service.socket.on(clientEvent: .connect) { (data, ack) in
            loadUserData()
        }
    }

    func loadUserData() -> Void {
        let data: [String: Int] = ["userId": UserDefaults.standard.integer(forKey: "userId")]
        service.socket.emit(state.events.dashboard, data)
        service.socket.on(state.events.dashboard) { data, ack in
            let obj = service.decodeData(data)
            if (obj.isEmpty) {
                return
            }

            user.setUser(obj)

            let sid = obj["activeGameSID"] as? String ?? ""
            let gamesPlayed = obj["gamesPlayed"] as! Int
            let wins = obj["wins"] as! Int
            let losses = obj["losses"] as! Int

            state.gamesPlayed = gamesPlayed
            state.wins = wins
            state.losses = losses

            if sid != "" {
                state.hasActiveGame = true
            }
            
            state.toggles.loading = false
        }

        service.socket.emit("getmovies")
        service.socket.on("getmovies") { data, ack in
            let obj = service.decodeData2(data)!
            if (obj.isEmpty) {
                return
            }
        }
    }


    var body: some View {
        ZStack() {
            Loader(isLoading: $state.toggles.loading)

            VStack {
                GroupBox() {
                    VStack {
                        NavigationLink(destination: SettingsView()) {
                            Image(systemName: "person.crop.square.fill")
                                .font(.system(size: 25))
                                .foregroundColor(.accentColor)
                        }
                        .isDetailLink(false)
                    }
                    .padding(.bottom, 10)

                    Text("username")
                        .foregroundColor(.accentColor)
                        .fontWeight(.black)
                        .font(.system(size: 14))
                    Text(String(user.username))
                        .foregroundColor(.gray)
                        .fontWeight(.black)
                        .font(.system(size: 20))
                        .padding(.bottom, 10)
                    
                    Text("rank")
                        .foregroundColor(.accentColor)
                        .fontWeight(.black)
                        .font(.system(size: 14))
                    Text(String(user.rank))
                        .foregroundColor(.gray)
                        .fontWeight(.black)
                        .font(.system(size: 20))
                        .padding(.bottom, 10)
                    
                    Text("elo")
                        .foregroundColor(.accentColor)
                        .fontWeight(.black)
                        .font(.system(size: 14))
                    Text(String(user.elo))
                        .foregroundColor(.gray)
                        .fontWeight(.black)
                        .font(.system(size: 20))
                        .padding(.bottom, 10)
                }
                .groupBoxStyle(CardGroupBoxStyle())

                GameHistoryWidget().environmentObject(state)
                GameModeWidget().environmentObject(state)

                Spacer()

                VStack {
                    ActiveGameButton().environmentObject(state)
                }
            }
        }
        
        .navigationBarBackButtonHidden(true)

        .onAppear() {
            loadDashboardView()
            func parseMovies() -> [MovieStruct] {
                let url = Bundle.main.url(forResource: "movies", withExtension: "json")!
                let data = try! Data(contentsOf: url)
                let movies = try! JSONDecoder().decode([MovieStruct].self, from: data)
                return movies
            }
        }
        
        .onDisappear() {
            service.socket.off(state.events.dashboard)
            service.socket.off(state.events.search)
            service.socket.off(state.events.connected)
            service.socket.off(state.events.cancel)
        }

        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                HStack {
                    NavigationLink(destination: SettingsView()) {
                        Image(systemName: "gear").renderingMode(.template)
                    }
                    .isDetailLink(false)
                }
            }
        }
    }
}
