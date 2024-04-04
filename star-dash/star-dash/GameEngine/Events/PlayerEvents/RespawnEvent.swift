//
//  RespawnEvent.swift
//  star-dash
//
//  Created by Jason Qiu on 17/3/24.
//

import Foundation

class RespawnEvent: Event {
    let timestamp: Date
    let playerId: EntityId
    let newPosition: CGPoint

    init(on playerId: EntityId, to newPosition: CGPoint) {
        self.timestamp = Date.now
        self.playerId = playerId
        self.newPosition = newPosition
    }

    var playerIdForEvent: EntityId? {
        playerId
    }
}
