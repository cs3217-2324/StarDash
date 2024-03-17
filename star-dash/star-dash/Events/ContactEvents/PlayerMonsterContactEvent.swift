//
//  PlayerMonsterContactEvent.swift
//  star-dash
//
//  Created by Jason Qiu on 16/3/24.
//

import Foundation

class PlayerMonsterContactEvent: Event {
    let timestamp: Date
    let entityId: EntityId

    let monsterEntityId: EntityId

    init(from playerEntityId: EntityId, on monsterEntityId: EntityId) {
        self.timestamp = Date.now
        entityId = playerEntityId
        self.monsterEntityId = monsterEntityId
    }

    func execute(on target: EventModifiable) {
        // TODO: Determine if it's player attacking monster or vice versa.
        // Trigger HurtByMonsterEvent and AttackMonsterEvent correspondingly
    }
}
