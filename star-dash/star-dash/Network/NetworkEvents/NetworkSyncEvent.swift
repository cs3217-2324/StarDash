//
//  NetworkSyncEvent.swift
//  star-dash
//
//  Created by Lau Rui han on 15/4/24.
//

import Foundation
struct NetworkPlayerPosition: Codable {
    let playerIndex: Int
    let position: CGPoint
}

class NetworkSyncEvent: NetworkEvent {
    let data: Data
    init(playerIndex: Int, data: Data) {
        self.data = data
        super.init(event: .Sync, playerIndex: playerIndex, timestamp: Date.now)

    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        data = try container.decode(Data.self, forKey: .data)
        try super.init(from: decoder)
    }
    override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder) // Call super implementation first

        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(data, forKey: .data)
    }
    private enum CodingKeys: String, CodingKey {
        case data
    }
}
