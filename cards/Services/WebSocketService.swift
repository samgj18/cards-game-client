//
//  WebSocketService.swift
//  cards
//
//  Created by Samuel Gómez Jiménez on 5/08/21.
//

import Starscream

class WebSocketService: WebSocketDelegate, ObservableObject {
    @Published var isLoading = true
    @Published var winner = false
    @Published var loser = false
    @Published var player: Player?
    @Published var room: Room?
    @Published var message: BackPush?
    let name = UserDefaults.standard.array(forKey: "name")
    let socket: WebSocket!
    let server = WebSocketServer()
    let decoder = JSONDecoder()
    var text = "default"
    var timer = Timer()
    
    
    init() {
        var request = URLRequest(url: URL(string: "ws://2.tcp.ngrok.io:14744/ws/\(text)")!)
        request.timeoutInterval = 5
        socket = WebSocket(request: request)
        socket.delegate = self
        socket.connect()
        if let unwrapped = name {
            self.text = unwrapped.first as! String
        }
    }
    
    func didReceive(event: WebSocketEvent, client: WebSocket) {
        switch event {
        case .connected(_):
            scheduledTimerWithTimeInterval(invalidate: true)
            isLoading = false
        case .disconnected(_, _):
            isLoading = true
        case .text(let string):
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
                print("ERROR DECODING")
            }
            do {
                player = try decoder.decode(Player.self, from: string.data(using: .ascii)!)
            } catch {
                print("ERROR DECODING")
            }
            do {
                room = try decoder.decode(Room.self, from: string.data(using: .ascii)!)
            } catch {
                
                print("ERROR DECODING")
            }
        case .binary(_):
            print("binary")
        case .ping(_):
            break
        case .pong(_):
            break
        case .viabilityChanged(_):
            if (isLoading) {
                scheduledTimerWithTimeInterval(invalidate: false)
            }
            break
        case .reconnectSuggested(_):
            break
        case .cancelled:
            isLoading = true
        case .error(_):
            scheduledTimerWithTimeInterval(invalidate: false)
            isLoading = true
        }
    }
    
    func scheduledTimerWithTimeInterval(invalidate: Bool){
        if (invalidate){
            print("Timer invalid")
            timer.invalidate()
        } else {
            print("Trying connection")
            timer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(self.connectToSocket), userInfo: nil, repeats: true)
        }
        
    }
    
    @objc func connectToSocket(){
        socket.connect()
    }
}
