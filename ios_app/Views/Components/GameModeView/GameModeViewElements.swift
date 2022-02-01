import SwiftUI

struct NewGameButton: View {
    @EnvironmentObject var service: Service
    @EnvironmentObject var state: DashboardState

    var text: String
    var id: Int

    func searchForGame() -> Void {
        if (state.toggles.searching || state.toggles.loading || state.hasActiveGame) {
            return
        }

        state.toggles.loading = true
        state.toggles.searching = true

        let data: [String: Int] = ["userId": UserDefaults.standard.integer(forKey: "userId")]
        service.socket.emit(state.events.search, data)
        registerListeners()
    }

    func registerListeners() -> Void {
        service.socket.on(state.events.search) { data, ack in
            let obj = service.decodeData(data)
            if obj.isEmpty {
                return
            }
        }

        service.socket.on(state.events.connected) { data, ack in
            state.toggles.loading = false

            let obj = service.decodeData(data)
            if obj.isEmpty {
                return
            }

            state.triggers.newGame = true
        }
    }

    var body: some View {
        NavigationLink(destination: PeerGameView(), isActive: $state.triggers.newGame) {
            Button(text, action: searchForGame).buttonStyle(PrimaryButtonStyle())
        }
        .isDetailLink(false)
    }
}

struct CancelGameButton: View {
    @EnvironmentObject var service: Service
    @EnvironmentObject var state: DashboardState

    func cancel() -> Void {
        if !state.toggles.searching {
            return
        }
        let data: [String: Int] = ["userId": UserDefaults.standard.integer(forKey: "userId")]
        service.socket.emit(state.events.cancel, data)
        service.socket.on(state.events.cancel) { data, ack in
            state.toggles.loading = false
            state.toggles.searching = false
        }
    }

    var body: some View {
        if state.toggles.searching {
            Button("Cancel", action: cancel).buttonStyle(RedButtonStyle())
        }
    }
}
