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

    init(on entityId: EntityId) {
        timestamp = Date.now
        self.entityId = entityId
    }

    func execute(on target: EventModifiable) {
        guard let healthSystem = target.system(ofType: HealthSystem.self) else {
            return
        }
        healthSystem.applyHealthChange(to: entityId, healthChange: GameConstants.HealthChange.attackedByMonster)

        if !healthSystem.hasHealth(for: entityId) {
            target.add(event: PlayerDeathEvent(on: entityId))
        }
    }
}
