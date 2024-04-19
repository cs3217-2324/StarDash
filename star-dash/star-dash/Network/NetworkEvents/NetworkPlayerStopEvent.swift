//
//  NetworkPlayerStopEvent.swift
//  star-dash
//
//  Created by Lau Rui han on 8/4/24.
//

import Foundation
class NetworkPlayerStopEvent: NetworkEvent {

    init(playerIndex: Int) {
        super.init(event: .PlayerStop, playerIndex: playerIndex, timestamp: Date.now)

    }

    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }
}
