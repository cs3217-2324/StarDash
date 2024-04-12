//
//  AttackSystem.swift
//  star-dash
//
//  Created by Ho Jun Hao on 25/3/24.
//

import Foundation

class AttackSystem: System {
    var isActive: Bool
    var dispatcher: EventModifiable?
    var entityManager: EntityManager
    var eventHandlers: [ObjectIdentifier: (Event) -> Void] = [:]

    init(_ entityManager: EntityManager, dispatcher: EventModifiable? = nil) {
        self.isActive = true
        self.entityManager = entityManager
        self.dispatcher = dispatcher
        setup()
    }

    func setup() {
        dispatcher?.registerListener(self)

        eventHandlers[ObjectIdentifier(MonsterAttackPlayerEvent.self)] = { event in
            if let monsterAttackPlayerEvent = event as? MonsterAttackPlayerEvent {
                self.handleMonsterAttackPlayerEvent(event: monsterAttackPlayerEvent)
            }
        }
        eventHandlers[ObjectIdentifier(PlayerAttackMonsterEvent.self)] = { event in
            if let playerAttackMonsterEvent = event as? PlayerAttackMonsterEvent {
                self.handlePlayerAttackMonsterEvent(event: playerAttackMonsterEvent)
            }
        }
    }

    private func handleMonsterAttackPlayerEvent(event: MonsterAttackPlayerEvent) {
        guard let healthSystem = dispatcher?.system(ofType: HealthSystem.self),
              let positionSystem = dispatcher?.system(ofType: PositionSystem.self),
              let physicsSystem = dispatcher?.system(ofType: PhysicsSystem.self) else {
            return
        }

        guard let monsterPosition = positionSystem.getPosition(of: event.monsterId),
              let playerPosition = positionSystem.getPosition(of: event.playerId) else {
            return
        }

        healthSystem.applyHealthChange(to: event.playerId, healthChange: GameConstants.HealthChange.attackedByMonster)

        let isMonsterToRight = monsterPosition.x > playerPosition.x
        let impulse = isMonsterToRight
                      ? GameConstants.DamageImpulse.attackedByMonster * -1
                      : GameConstants.DamageImpulse.attackedByMonster

        physicsSystem.applyImpulse(to: event.playerId, impulse: impulse)
    }

    private func handlePlayerAttackMonsterEvent(event: PlayerAttackMonsterEvent) {
        guard let healthSystem = dispatcher?.system(ofType: HealthSystem.self) else {
            return
        }

        healthSystem.applyHealthChange(to: event.monsterId, healthChange: GameConstants.HealthChange.attackedByPlayer)
    }
}
