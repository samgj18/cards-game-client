//
//  GameView.swift
//  cards
//
//  Created by Samuel Gómez Jiménez on 4/08/21.
//

import SwiftUI

struct GameView: View {
    @State private var playerOne = 2
    @State private var playerTwo = 2
    @State private var pressed = false
    @State private var showingAlert = true
    @State private var action: AlertAction?
    @State private var hide = false
    
    @ObservedObject var websocket = WebSocketService()
    
    
    var body: some View {
        LoadingView(isShowing: $websocket.isLoading) {
            VStack {
                Spacer()
                
                Image("logo").resizable()
                    .frame(width: 100.0, height: 100.0)
                
                Spacer()
                
                HStack{
                    if((websocket.room?.card) != nil) {
                        Image(self.hide ? "back" : "card" + String(websocket.room!.card))
                            .opacity(self.pressed ? 1.5 : 1.0)
                            .blur(radius: self.hide ? 9 : 0)
                            .scaleEffect(self.pressed ? 1.2 : 1.0)
                        
//                        Image("card" + String(playerTwo)).blur(radius: 9)
                    } else {
                        ActivityIndicator(isAnimating: Binding<Bool>(get: { (websocket.room?.card) == nil }, set: { _ in }), style: .large)
                    }
                }
                
                Spacer()
                
                HStack{
                    Button(action: {
                        self.playerTwo = Int.random(in: 2 ... 14)
                        if ((websocket.room?.roomId) != nil && (websocket.player?.playerId) != nil) {
                            self.writeText(roomId: websocket.room!.roomId, playerId: websocket.player!.playerId, action: "playCard")
                        }
                        self.hide = false
                        print("Play card")
                    }, label: {
                        Image("dealbutton").renderingMode(.original)
                    }).onLongPressGesture(minimumDuration: 2.5, maximumDistance: .infinity, pressing: { pressing in
                        withAnimation(.easeInOut(duration: 1.0)) {
                            self.pressed = pressing
                        }
                    }, perform: { })
                    
                    Button(action: {
                        if ((websocket.room?.roomId) != nil && (websocket.player?.playerId) != nil) {
                            self.writeText(roomId: websocket.room!.roomId, playerId: websocket.player!.playerId, action: "fold")
                        }
                        self.hide = true
                        print("Fold")
                    }, label: {
                        Image("foldbutton").renderingMode(.original)
                    }).onLongPressGesture(minimumDuration: 2.5, maximumDistance: .infinity, pressing: { pressing in
                        withAnimation(.easeInOut(duration: 1.0)) {
                            self.pressed = pressing
                        }
                    }, perform: { })
                }
                
                Spacer()
                if ((websocket.player?.balance) != nil) {
                    Text("Balance: \(websocket.player!.balance)").font(AppFont.commonFont(fontSize: 16))
                }
                
                Spacer()
                
                if websocket.winner {
                    AlertView(shown: $websocket.winner, closureA: $action, isSuccess: true, message: "Winner")
                } else if (websocket.loser) {
                    AlertView(shown: $websocket.loser, closureA: $action, isSuccess: false, message: "Loser")
                }
            
            }
            .animation(.easeIn)
            .preferredColorScheme(.dark)
        }
    }
    
    func writeText(roomId: String, playerId: String, action: String) {
        let string = "{\"roomId\":\"\(roomId)\",\"playerId\":\"\(playerId)\",\"action\":\"\(action)\"}"
        websocket.socket.write(string: string) {
            print("Transaction completed")
        }
    }
    
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
    }
}
