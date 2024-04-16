//
//  NetworkPlayerLeaveRoomEvent.swift
//  star-dash
//
//  Created by Lau Rui han on 17/4/24.
//

import Foundation
class NetworkPlayerLeaveRoomEvent: NetworkEvent {

    var totalNumberOfPlayers: Int
    var newPlayerIndex: Int
    init(playerIndex: Int, newPlayerIndex: Int, totalNumberOfPlayers: Int) {
        self.totalNumberOfPlayers = totalNumberOfPlayers
        self.newPlayerIndex = newPlayerIndex
        super.init(event: .PlayerJoinRoom, playerIndex: playerIndex, timestamp: Date.now)

    }
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        totalNumberOfPlayers = try container.decode(Int.self, forKey: .totalNumberOfPlayers)
        newPlayerIndex = try container.decode(Int.self, forKey: .newPlayerIndex)
        try super.init(from: decoder)
    }
    override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder) // Call super implementation first

        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(totalNumberOfPlayers, forKey: .totalNumberOfPlayers)
        try container.encode(newPlayerIndex, forKey: .newPlayerIndex)
    }
    private enum CodingKeys: String, CodingKey {
        case totalNumberOfPlayers
        case newPlayerIndex
    }

}
