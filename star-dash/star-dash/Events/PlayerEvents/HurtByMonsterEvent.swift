//
//  HurtByMonsterEvent.swift
//  star-dash
//
//  Created by Jason Qiu on 16/3/24.
//

import Foundation

class HurtByMonsterEvent: Event {
    let timestamp: Date
    let entityId: EntityId

    init(on entityId: EntityId) {
        timestamp = Date.now
        self.entityId = entityId
    }

    func execute(on target: EventModifiable) {
        // TODO: Get health system and decrease health of attacked player.
        // If health below 0, trigger DeathEvent
    }
}
