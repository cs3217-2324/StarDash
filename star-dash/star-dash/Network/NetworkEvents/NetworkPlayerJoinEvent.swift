//
//  NetworkPlayerJoinEvent.swift
//  star-dash
//
//  Created by Lau Rui han on 8/4/24.
//

import Foundation
class NetworkPlayerJoinEvent: NetworkEvent, Codable {
    
    var event: NetworkEventType
    
    var playerIndex: Int

    var totalNumberOfPlayers: Int
    
    init(playerIndex: Int, totalNumberOfPlayers: Int) {
        self.event = .PlayerJoinRoom
        self.playerIndex = playerIndex
        self.totalNumberOfPlayers = totalNumberOfPlayers
    }
}
