//
//  NetworkPlayerJoinEvent.swift
//  star-dash
//
//  Created by Lau Rui han on 8/4/24.
//

import Foundation
class NetworkPlayerJoinEvent: NetworkEvent {

    var totalNumberOfPlayers: Int

    init(playerIndex: Int, totalNumberOfPlayers: Int) {
        self.totalNumberOfPlayers = totalNumberOfPlayers
        super.init(event: .PlayerJoinRoom, playerIndex: playerIndex, timestamp: Date.now)

    }
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        totalNumberOfPlayers = try container.decode(Int.self, forKey: .totalNumberOfPlayers)
        try super.init(from: decoder)
    }
    override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder) // Call super implementation first

        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(totalNumberOfPlayers, forKey: .totalNumberOfPlayers)
    }
    private enum CodingKeys: String, CodingKey {
        case totalNumberOfPlayers
    }

}
