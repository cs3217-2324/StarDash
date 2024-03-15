//
//  PlayerDeathEvent.swift
//  star-dash
//
//  Created by Jason Qiu on 16/3/24.
//

import Foundation

class DeathEvent: Event {
    let entityId: EntityId
    let timestamp: Date

    init(on entityId: EntityId, timestamp: Date = Date.now) {
        self.entityId = entityId
        self.timestamp = timestamp
    }

    func execute(on target: EventModifiable) {
        // TODO: Check if entity is player. If so, add RespawnEvent to target
    }
}
