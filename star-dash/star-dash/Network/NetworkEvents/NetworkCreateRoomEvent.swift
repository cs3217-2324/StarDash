//
//  NetworkCreateRoomEvent.swift
//  star-dash
//
//  Created by Lau Rui han on 21/4/24.
//

import Foundation
class NetworkCreateRoomEvent: NetworkEvent {

    var roomCode: String

    init(playerIndex: Int, roomCode: String) {
        self.roomCode = roomCode
        super.init(event: .SelectMode, playerIndex: playerIndex, timestamp: Date.now)
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        roomCode = try container.decode(String.self, forKey: .roomCode)
        try super.init(from: decoder)
    }
    override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder) // Call super implementation first

        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(roomCode, forKey: .roomCode)
    }

    private enum CodingKeys: String, CodingKey {
        case roomCode
    }

}
