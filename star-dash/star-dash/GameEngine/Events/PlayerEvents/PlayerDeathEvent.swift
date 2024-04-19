//
//  PlayerDeathEvent.swift
//  star-dash
//
//  Created by Jason Qiu on 17/3/24.
//

import Foundation

class PlayerDeathEvent: Event {
    let playerId: EntityId

    init(on playerId: EntityId, timestamp: Date) {
        self.playerId = playerId
        super.init(playerIdForEvent: playerId, timestamp: timestamp)
    }

    convenience init(on playerId: EntityId) {
        self.init(on: playerId, timestamp: Date.now)
    }
}
