//
//  PlayerDeathEvent.swift
//  star-dash
//
//  Created by Jason Qiu on 16/3/24.
//

import Foundation

class DeathEvent: Event {
    let timestamp: Date
    let entityId: EntityId

    init(on entityId: EntityId) {
        self.timestamp = Date.now
        self.entityId = entityId
    }

    func execute(on target: EventModifiable) {
        // TODO: Check if entity is player. If so, add RespawnEvent to target
    }
}
