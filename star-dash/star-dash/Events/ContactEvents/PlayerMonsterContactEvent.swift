//
//  PlayerMonsterContactEvent.swift
//  star-dash
//
//  Created by Jason Qiu on 16/3/24.
//

import Foundation

class PlayerMonsterContactEvent: Event {
    var entityId: EntityId

    let timestamp: Date
    let monsterId: EntityId

    init(from playerId: EntityId, on monsterId: EntityId) {
        self.timestamp = Date.now
        self.entityId = playerId
        self.monsterId = monsterId
    }
}
