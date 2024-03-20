//
//  PlayerAttackMonsterEvent.swift
//  star-dash
//
//  Created by Jason Qiu on 17/3/24.
//

import Foundation

class PlayerAttackMonsterEvent: Event {
    private static let attackImpulse = CGVector(dx: 0, dy: 400)

    let timestamp: Date
    let entityId: EntityId

    init(on entityId: EntityId) {
        timestamp = Date.now
        self.entityId = entityId
    }

    func execute(on target: EventModifiable) {
        guard let healthSystem = target.system(ofType: HealthSystem.self),
              let physicSystem = target.system(ofType: PhysicsSystem.self) else {
            return
        }

        healthSystem.applyHealthChange(to: entityId, healthChange: GameConstants.HealthChange.attackedByPlayer)
        physicSystem.applyImpulse(to: entityId, impulse: PlayerAttackMonsterEvent.attackImpulse)

        if !healthSystem.hasHealth(for: entityId) {
            target.add(event: MonsterDeathEvent(on: entityId))
        }
    }
}
