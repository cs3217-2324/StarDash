//
//  AttackEvent.swift
//  star-dash
//
//  Created by Jason Qiu on 16/3/24.
//

import Foundation

class AttackEvent: Event {
    let timestamp: Date
    let entityId: EntityId

    let attackedEntityId: EntityId

    init(by entityId: EntityId, on attackedEntityId: EntityId) {
        timestamp = Date.now
        self.entityId = entityId
        self.attackedEntityId = attackedEntityId
    }

    func execute(on target: EventModifiable) {
        // TODO: Get health system and decrease health of attacked entity.
        // If health below 0, trigger DeathEvent
    }
}
