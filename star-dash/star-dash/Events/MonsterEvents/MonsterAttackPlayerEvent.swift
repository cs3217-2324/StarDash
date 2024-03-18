//
//  MonsterAttackPlayerEvent.swift
//  star-dash
//
//  Created by Jason Qiu on 16/3/24.
//

import Foundation

class MonsterAttackPlayerEvent: Event {
    private static let damageImpulse = CGVector(dx: 500, dy: 0)

    let timestamp: Date
    let entityId: EntityId
    let monsterId: EntityId

    init(from monsterId: EntityId, on entityId: EntityId) {
        timestamp = Date.now
        self.entityId = entityId
        self.monsterId = monsterId
    }

    func execute(on target: EventModifiable) {
        guard let healthSystem = target.system(ofType: HealthSystem.self),
              let positionSystem = target.system(ofType: PositionSystem.self),
              let physicsSystem = target.system(ofType: PhysicsSystem.self) else {
            return
        }

        guard let monsterPosition = positionSystem.getPosition(of: monsterId),
              let playerPosition = positionSystem.getPosition(of: entityId) else {
            return
        }

        healthSystem.applyHealthChange(to: entityId, healthChange: GameConstants.HealthChange.attackedByMonster)

        let isMonsterToRight = monsterPosition.x > playerPosition.x
        let impulse = isMonsterToRight
                      ? MonsterAttackPlayerEvent.damageImpulse * -1
                      : MonsterAttackPlayerEvent.damageImpulse

        physicsSystem.applyImpulse(to: entityId, impulse: impulse)

        if !healthSystem.hasHealth(for: entityId) {
            target.add(event: PlayerDeathEvent(on: entityId))
        }
    }
}
