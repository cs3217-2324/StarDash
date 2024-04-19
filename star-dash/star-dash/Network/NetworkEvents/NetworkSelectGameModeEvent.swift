//
//  NetworkSelectGameModeEvent.swift
//  star-dash
//
//  Created by Lau Rui han on 19/4/24.
//

import Foundation
class NetworkSelectGameModeEvent: NetworkEvent {

    var gameMode: GameModeType

    init(playerIndex: Int, gameMode: GameModeType) {
        self.gameMode = gameMode
        super.init(event: .SelectMode, playerIndex: playerIndex, timestamp: Date.now)
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        gameMode = try container.decode(GameModeType.self, forKey: .gameMode)
        try super.init(from: decoder)
    }
    override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder) // Call super implementation first

        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(gameMode, forKey: .gameMode)
    }

    private enum CodingKeys: String, CodingKey {
        case gameMode
    }

}
