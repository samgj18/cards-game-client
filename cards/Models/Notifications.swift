//
//  Notifications.swift
//  cards
//
//  Created by Samuel Gómez Jiménez on 5/08/21.
//

import Foundation

struct Room: Codable {
    let roomId: String
    let card: Int
    init(roomId: String, card: Int) {
        self.roomId = roomId
        self.card = card
    }
}

struct Player: Codable {
    let playerId: String
    let balance: Int
    init(playerId: String, balance: Int) {
        self.playerId = playerId
        self.balance = balance
    }
}

struct BackPush: Codable {
    let message: String
    init(message: String) {
        self.message = message
    }
}
