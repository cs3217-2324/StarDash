//
//  PickupCollectibleEvent.swift
//  star-dash
//
//  Created by Jason Qiu on 16/3/24.
//

import Foundation

class PickupCollectibleEvent: Event {
    let timestamp: Date
    let entityId: EntityId

    let collectibleEntityId: EntityId

    init(by entityId: EntityId, collectibleEntityId: EntityId) {
        timestamp = Date.now
        self.entityId = entityId
        self.collectibleEntityId = collectibleEntityId
    }

    func execute(on target: EventModifiable) {
        // TODO: Add player score
        target.add(event: RemoveEvent(on: collectibleEntityId))
    }
}
