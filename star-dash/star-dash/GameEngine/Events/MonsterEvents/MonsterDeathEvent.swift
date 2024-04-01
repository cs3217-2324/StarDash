//
//  MonsterDeathEvent.swift
//  star-dash
//
//  Created by Jason Qiu on 16/3/24.
//

import Foundation

class MonsterDeathEvent: Event {
    let timestamp: Date
    let monsterId: EntityId
    let playerId: EntityId

    init(on monsterId: EntityId, causedBy playerId: EntityId) {
        self.timestamp = Date.now
        self.monsterId = monsterId
        self.playerId = playerId
    }

    var playerIdForEvent: EntityId? {
        playerId
    }
}
