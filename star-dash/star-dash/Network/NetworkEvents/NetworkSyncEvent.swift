//
//  NetworkSyncEvent.swift
//  star-dash
//
//  Created by Lau Rui han on 15/4/24.
//

import Foundation

struct NetworkPlayerData: Codable {
    let playerIndex: Int
    let position: CGPoint
    let score: Int
}

class NetworkSyncEvent: NetworkEvent {
    let playerData: NetworkPlayerData
    init(playerIndex: Int, playerData: NetworkPlayerData) {
        self.playerData = playerData
        super.init(event: .Sync, playerIndex: playerIndex, timestamp: Date.now)

    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        playerData = try container.decode(NetworkPlayerData.self, forKey: .playerData)
        try super.init(from: decoder)
    }
    override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder) // Call super implementation first

        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(playerData, forKey: .playerData)
    }
    private enum CodingKeys: String, CodingKey {
        case playerData
    }
}
