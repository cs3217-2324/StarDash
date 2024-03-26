//
//  MonsterAttackPlayerEvent.swift
//  star-dash
//
//  Created by Jason Qiu on 16/3/24.
//

import Foundation

class MonsterAttackPlayerEvent: Event {
    let timestamp: Date
    let entityId: EntityId
    let monsterId: EntityId

    init(from monsterId: EntityId, on entityId: EntityId) {
        timestamp = Date.now
        self.entityId = entityId
        self.monsterId = monsterId
    }
}
