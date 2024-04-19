//
//  RespawnEvent.swift
//  star-dash
//
//  Created by Jason Qiu on 17/3/24.
//

import Foundation

class RespawnEvent: Event {
    let playerId: EntityId
    let newPosition: CGPoint

    init(on playerId: EntityId, to newPosition: CGPoint, timestamp: Date) {
        self.playerId = playerId
        self.newPosition = newPosition
        super.init(playerIdForEvent: playerId, timestamp: timestamp)
    }
    convenience init(on playerId: EntityId, to newPosition: CGPoint) {
        self.init(on: playerId, to: newPosition, timestamp: Date.now)
    }

}
