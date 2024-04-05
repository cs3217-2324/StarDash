//
//  MonsterSystem.swift
//  star-dash
//
//  Created by Ho Jun Hao on 26/3/24.
//

import Foundation

class MonsterSystem: System {
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

    func update(by deltaTime: TimeInterval) {
        let monsterEntities = entityManager.entities(ofType: Monster.self)

        for monsterEntity in monsterEntities {
            guard let physicsSystem = dispatcher?.system(ofType: PhysicsSystem.self),
                  let monsterVelocity = physicsSystem.velocity(of: monsterEntity.id) else {
                continue
            }

            let newVelocity = monsterVelocity.dx > 0
                              ? PhysicsConstants.Monster.moveVelocityRight
                              : PhysicsConstants.Monster.moveVelocityLeft
            physicsSystem.setVelocity(to: monsterEntity.id, velocity: newVelocity)
        }
    }

    func setup() {
        dispatcher?.registerListener(self)

        eventHandlers[ObjectIdentifier(MonsterDeathEvent.self)] = { event in
            if let monsterDeathEvent = event as? MonsterDeathEvent {
                self.handleMonsterDeathEvent(event: monsterDeathEvent)
            }
        }
        eventHandlers[ObjectIdentifier(MonsterMovementReversalEvent.self)] = { event in
            if let monsterMovementReversalEvent = event as? MonsterMovementReversalEvent {
                self.handleMonsterMovementReversalEvent(event: monsterMovementReversalEvent)
            }
        }
    }

    private func handleMonsterDeathEvent(event: MonsterDeathEvent) {
        dispatcher?.add(event: RemoveEvent(on: event.monsterId))
    }

    private func handleMonsterMovementReversalEvent(event: MonsterMovementReversalEvent) {
        guard let physicsSystem = dispatcher?.system(ofType: PhysicsSystem.self),
              let spriteSystem = dispatcher?.system(ofType: SpriteSystem.self) else {
            return
        }

        let newVelocity = event.isLeft
                          ? PhysicsConstants.Monster.moveVelocityLeft
                          : PhysicsConstants.Monster.moveVelocityRight

        physicsSystem.setVelocity(to: event.monsterId, velocity: newVelocity)
        spriteSystem.startAnimation(of: event.monsterId, named: event.isLeft ? "runLeft" : "run")
    }
}
