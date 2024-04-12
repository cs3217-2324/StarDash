//
//  MonsterDeathEvent.swift
//  star-dash
//
//  Created by Jason Qiu on 16/3/24.
//

import Foundation

class MonsterDeathEvent: Event {
    let monsterId: EntityId
    let playerId: EntityId

    init(on monsterId: EntityId, causedBy playerId: EntityId, timestamp: Date) {
        self.monsterId = monsterId
        self.playerId = playerId
        super.init(playerIdForEvent: playerId, timestamp: timestamp)
    }

    convenience init(on monsterId: EntityId, causedBy playerId: EntityId) {
        self.init(on: monsterId, causedBy: playerId, timestamp: Date.now)
    }
}
