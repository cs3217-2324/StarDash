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
        setUpEventHandlers()
    }

    func setUpEventHandlers() {
        dispatcher?.registerListener(for: RemoveEvent.self, listener: self)
        dispatcher?.registerListener(for: PlayerFloorContactEvent.self, listener: self)
        dispatcher?.registerListener(for: PlayerMonsterContactEvent.self, listener: self)

        eventHandlers[ObjectIdentifier(RemoveEvent.self)] = { event in
            if let removeEvent = event as? RemoveEvent {
                self.handleRemoveEvent(event: removeEvent)
            }
        }
        eventHandlers[ObjectIdentifier(PlayerFloorContactEvent.self)] = { event in
            if let playerFloorContactEvent = event as? PlayerFloorContactEvent {
                self.handlePlayerFloorContactEvent(event: playerFloorContactEvent)
            }
        }
        eventHandlers[ObjectIdentifier(PlayerMonsterContactEvent.self)] = { event in
            if let playerMonsterContactEvent = event as? PlayerMonsterContactEvent {
                self.handlePlayerMonsterContactEvent(event: playerMonsterContactEvent)
            }
        }
    }

    private func handleRemoveEvent(event: RemoveEvent) {
        guard let entity = dispatcher?.entity(with: event.entityId) else {
            return
        }
        dispatcher?.remove(entity: entity)
    }

    private func handlePlayerFloorContactEvent(event: PlayerFloorContactEvent) {
        guard let positionComponent = entityManager.component(ofType: PositionComponent.self, of: event.entityId),
              let playerComponent = entityManager.component(ofType: PlayerComponent.self, of: event.entityId),
              positionComponent.position.y > event.contactPoint.y else {
            return
        }

        playerComponent.canJump = true
        playerComponent.canMove = true
    }

    private func handlePlayerMonsterContactEvent(event: PlayerMonsterContactEvent) {
        guard let positionSystem = dispatcher?.system(ofType: PositionSystem.self),
              let physicsSystem = dispatcher?.system(ofType: PhysicsSystem.self) else {
            return
        }

        guard let playerPosition = positionSystem.getPosition(of: event.entityId),
              let monsterPosition = positionSystem.getPosition(of: event.monsterId) else {
            return
        }

        guard let playerSize = physicsSystem.getSize(of: event.entityId),
              let monsterSize = physicsSystem.getSize(of: event.monsterId) else {
            return
        }

        let isPlayerAbove = playerPosition.y - (playerSize.height / 2) >= monsterPosition.y + (monsterSize.height / 2)

        if isPlayerAbove {
            dispatcher?.add(event: PlayerAttackMonsterEvent(on: event.monsterId))
        } else {
            dispatcher?.add(event: MonsterAttackPlayerEvent(from: event.monsterId, on: event.entityId))
        }
    }
}
