//
//  PlayerDeathEvent.swift
//  star-dash
//
//  Created by Jason Qiu on 17/3/24.
//

import Foundation

class PlayerDeathEvent: Event {
    let timestamp: Date
    let entityId: EntityId

    init(on entityId: EntityId) {
        timestamp = Date.now
        self.entityId = entityId
    }

    func execute(on target: EventModifiable) {
        // TODO: Where should player respawn to?
        // target.add(event: RespawnEvent(on: entityId, to: ))
    }
}
