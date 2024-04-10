//
//  CollisionSystem.swift
//  star-dash
//
//  Created by Ho Jun Hao on 26/3/24.
//

import Foundation

class CollisionSystem: System {
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

        eventHandlers[ObjectIdentifier(RemoveEvent.self)] = { event in
            if let removeEvent = event as? RemoveEvent {
                self.handleRemoveEvent(event: removeEvent)
            }
        }
        eventHandlers[ObjectIdentifier(PlayerMonsterContactEvent.self)] = { event in
            if let playerMonsterContactEvent = event as? PlayerMonsterContactEvent {
                self.handlePlayerMonsterContactEvent(event: playerMonsterContactEvent)
            }
        }
        eventHandlers[ObjectIdentifier(MonsterObstacleContactEvent.self)] = { event in
            if let monsterObstacleContactEvent = event as? MonsterObstacleContactEvent {
                self.handleMonsterObstacleContactEvent(event: monsterObstacleContactEvent)
            }
        }
    }

    private func handleRemoveEvent(event: RemoveEvent) {
        entityManager.remove(entityId: event.entityId)
    }

    private func handlePlayerMonsterContactEvent(event: PlayerMonsterContactEvent) {
        if let hookOwnerComponent = entityManager
                                    .components(ofType: GrappleHookOwnerComponent.self)
                                    .first(where: { $0.ownerPlayerId == event.playerId }) {
            dispatcher?.add(event: ReleaseGrappleHookEvent(using: hookOwnerComponent.entityId))
        }

        guard let positionSystem = dispatcher?.system(ofType: PositionSystem.self),
              let deathSystem = dispatcher?.system(ofType: DeathSystem.self),
              let physicsSystem = dispatcher?.system(ofType: PhysicsSystem.self) else {
            return
        }

        guard let playerPosition = positionSystem.getPosition(of: event.playerId),
              let monsterPosition = positionSystem.getPosition(of: event.monsterId) else {
            return
        }

        guard let playerSize = physicsSystem.getSize(of: event.playerId),
              let monsterSize = physicsSystem.getSize(of: event.monsterId) else {
            return
        }

        let isPlayerAbove = playerPosition.y - (playerSize.height / 2 - 10)
                            >= monsterPosition.y + (monsterSize.height / 2 - 10)
        let isPlayerWithinMonsterWidth = playerPosition.x < (monsterPosition.x + (monsterSize.width / 2))
                                         || playerPosition.x > (monsterPosition.x - (monsterSize.width / 2))
        let isPlayerAttack = isPlayerAbove && isPlayerWithinMonsterWidth

        let isLeft = monsterPosition.x < playerPosition.x
        dispatcher?.add(event: MonsterMovementReversalEvent(on: event.monsterId, isLeft: isLeft))

        guard let isPlayerDead = deathSystem.isDead(entityId: event.playerId),
              let isMonsterDead = deathSystem.isDead(entityId: event.monsterId),
              !isPlayerDead && !isMonsterDead else {
            return
        }

        if isPlayerAttack {
            print("Player attack monster")
            dispatcher?.add(event: PlayerAttackMonsterEvent(from: event.playerId, on: event.monsterId))
        } else {
            print("Monster attack player")
            dispatcher?.add(event: MonsterAttackPlayerEvent(from: event.monsterId, on: event.playerId))
        }
    }

    private func handleMonsterObstacleContactEvent(event: MonsterObstacleContactEvent) {
        guard let positionSystem = dispatcher?.system(ofType: PositionSystem.self),
              let monsterPosition = positionSystem.getPosition(of: event.monsterId) else {
            return
        }

        let isLeft = monsterPosition.x < event.contactPoint.x

        dispatcher?.add(event: MonsterMovementReversalEvent(on: event.monsterId, isLeft: isLeft))
    }
}
