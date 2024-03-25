//
//  PlayerToolContactEvent.swift
//  star-dash
//
//  Created by Lau Rui han on 26/3/24.
//

import Foundation
class PlayerToolContactEvent: Event {
    let timestamp: Date
    let entityId: EntityId
    let toolId: EntityId

    init(from playerEntityId: EntityId, on toolEntityId: EntityId) {
        self.timestamp = Date.now
        self.entityId = playerEntityId
        self.toolId = toolEntityId
    }

    func execute(on target: EventModifiable) {
        target.add(event: RemoveEvent(on: self.toolId))
    }
}
