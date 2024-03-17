//
//  MonsterAttackPlayerEvent.swift
//  star-dash
//
//  Created by Jason Qiu on 16/3/24.
//

import Foundation

class MonsterAttackPlayerEvent: Event {
    private static let playerHealthDecrement = 20

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
        healthSystem.decreaseHealth(of: entityId, by: MonsterAttackPlayerEvent.playerHealthDecrement)

        if !healthSystem.hasHealth(for: entityId) {
            target.add(event: PlayerDeathEvent(on: entityId))
        }
    }
}
