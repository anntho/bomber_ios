import SwiftUI
import SocketIO

final class Service: ObservableObject {
    private var manager = SocketManager(
        socketURL: URL(string: "https://moviebomber.org")!,
        config: [.log(false), .compress]
    )
    
    @Published var connected: Bool = false

    var socket: SocketIO.SocketIOClient

    func decodeData(_ data: Array<Any>) -> [String: Any] {
        if data.isEmpty {
            return [:]
        }

        if let item = data[0] as? NSDictionary {
            let obj = item as! [String: Any]
            return obj
        }
        
        return [:]
    }

    func decodeData2(_ data: Array<Any>) -> [MovieStruct]? {
        if data.isEmpty {
            return nil
        }

        if let item = data[0] as? NSArray {
            let jsonString = convertIntoJSONString(arrayObject: item)!.data(using: .utf8)!
            let movies = try! JSONDecoder().decode([MovieStruct].self, from: jsonString)
            return movies
        }
        
        return nil
    }
    
    func convertIntoJSONString(arrayObject: NSArray) -> String? {
        do {
            let jsonData: Data = try JSONSerialization.data(withJSONObject: arrayObject, options: [])
            if  let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue) {
                return jsonString as String
            }
        }
        catch let error as NSError {
            print("Array convertIntoJSON - \(error.description)")
        }
        return nil
    }
    
    init() {
        socket = manager.defaultSocket
        socket.connect()
        
        socket.on(clientEvent: .connect) { (data, ack) in
            self.connected = true
        }
    }
}
