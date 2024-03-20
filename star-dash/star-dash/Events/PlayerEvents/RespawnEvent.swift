//
//  RespawnEvent.swift
//  star-dash
//
//  Created by Jason Qiu on 17/3/24.
//

import Foundation

class RespawnEvent: Event {
    let timestamp: Date
    let entityId: EntityId

    let newPosition: CGPoint

    init(on entityId: EntityId, to newPosition: CGPoint) {
        timestamp = Date.now
        self.entityId = entityId
        self.newPosition = newPosition
    }

    func execute(on target: EventModifiable) {
        target.add(event: TeleportEvent(on: entityId, to: newPosition))
    }
}
