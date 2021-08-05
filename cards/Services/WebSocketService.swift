
import Starscream

class WebSocketService: WebSocketDelegate, ObservableObject {
    let socket: WebSocket!
    @Published var isLoading = true
    @Published var winner = false
    @Published var loser = false
    @Published var player: Player?
    @Published var room: Room?
    @Published var message: BackPush?
    let server = WebSocketServer()
    let decoder = JSONDecoder()
    
    
    init() {
        var request = URLRequest(url: URL(string: "ws://2.tcp.ngrok.io:14744/ws/hardcodedfornow")!)
        request.timeoutInterval = 5
        socket = WebSocket(request: request)
        socket.delegate = self
        socket.connect()
        
    }
    
    
    // MARK: - WebSocketDelegate
    func didReceive(event: WebSocketEvent, client: WebSocket) {
        switch event {
        case .connected(let headers):
            isLoading = false
            print("websocket is connected: \(headers)")
        case .disconnected(let reason, let code):
            isLoading = false
            print("websocket is disconnected: \(reason) with code: \(code)")
        case .text(let string):
            print(string)
            do {
                message = try decoder.decode(BackPush.self, from: string.data(using: .ascii)!)
                if (message?.message == "win"){
                    self.winner = true
                    self.loser = false
                } else if (message?.message == "lost") {
                    self.winner = false
                    self.loser = true
                }
            } catch {
                print("Unexpected error: \(error).")
            }
            do {
                player = try decoder.decode(Player.self, from: string.data(using: .ascii)!)
            } catch {
                print("Unexpected error: \(error).")
            }
            do {
                room = try decoder.decode(Room.self, from: string.data(using: .ascii)!)
            } catch {
                
                print("Unexpected error: \(error).")
            }
        case .binary(let data):
            print("Received data: \(data.count)")
        case .ping(_):
            break
        case .pong(_):
            break
        case .viabilityChanged(_):
            break
        case .reconnectSuggested(_):
            break
        case .cancelled:
            isLoading = true
        case .error(let error):
            isLoading = true
            handleError(error)
        }
    }
    
    func handleError(_ error: Error?) {
        if let e = error as? WSError {
            print("websocket encountered an error: \(e.message)")
        } else if let e = error {
            print("websocket encountered an error: \(e.localizedDescription)")
        } else {
            print("websocket encountered an error")
        }
    }
    
    // MARK: Disconnect Action
    
    @IBAction func disconnect(_ sender: UIBarButtonItem) {
        if !isLoading {
            sender.title = "Connect"
            socket.disconnect()
        } else {
            sender.title = "Disconnect"
            socket.connect()
        }
    }
    
}
