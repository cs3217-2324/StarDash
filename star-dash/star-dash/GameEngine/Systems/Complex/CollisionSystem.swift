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
        dispatcher?.registerListener(for: RemoveEvent.self, listener: self)
        dispatcher?.registerListener(for: PlayerFloorContactEvent.self, listener: self)
        dispatcher?.registerListener(for: PlayerMonsterContactEvent.self, listener: self)
        dispatcher?.registerListener(for: PlayerObstacleContactEvent.self, listener: self)
        dispatcher?.registerListener(for: PlayerToolContactEvent.self, listener: self)

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
        eventHandlers[ObjectIdentifier(PlayerObstacleContactEvent.self)] = { event in
            if let playerObstacleContactEvent = event as? PlayerObstacleContactEvent {
                self.handlePlayerObstacleContactEvent(event: playerObstacleContactEvent)
            }
        }
        eventHandlers[ObjectIdentifier(PlayerToolContactEvent.self)] = { event in
            if let playerToolContactEvent = event as? PlayerToolContactEvent {
                self.handlePlayerToolContactEvent(event: playerToolContactEvent)
            }
        }
    }

    private func handleRemoveEvent(event: RemoveEvent) {
        entityManager.remove(entityId: event.entityId)
    }

    private func handlePlayerFloorContactEvent(event: PlayerFloorContactEvent) {
        guard let playerSystem = dispatcher?.system(ofType: PlayerSystem.self),
              let positionSystem = dispatcher?.system(ofType: PositionSystem.self),
              let playerPosition = positionSystem.getPosition(of: event.playerId),
              playerPosition.y > event.contactPoint.y else {
            return
        }

        playerSystem.setCanJump(to: event.playerId, canJump: true)
        playerSystem.setCanMove(to: event.playerId, canMove: true)
    }

    private func handlePlayerMonsterContactEvent(event: PlayerMonsterContactEvent) {
        guard let positionSystem = dispatcher?.system(ofType: PositionSystem.self),
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

        let isPlayerAbove = playerPosition.y - (playerSize.height / 2) >= monsterPosition.y + (monsterSize.height / 2)

        if isPlayerAbove {
            dispatcher?.add(event: PlayerAttackMonsterEvent(from: event.playerId, on: event.monsterId))
        } else {
            dispatcher?.add(event: MonsterAttackPlayerEvent(from: event.monsterId, on: event.playerId))
        }
    }

    private func handlePlayerObstacleContactEvent(event: PlayerObstacleContactEvent) {
        guard let playerSystem = dispatcher?.system(ofType: PlayerSystem.self),
              let positionSystem = dispatcher?.system(ofType: PositionSystem.self),
              let playerPosition = positionSystem.getPosition(of: event.playerId),
              let obstaclePosition = positionSystem.getPosition(of: event.playerId),
              playerPosition.y - PhysicsConstants.Dimensions.player.height / 2 >
              obstaclePosition.y + PhysicsConstants.Dimensions.obstacle.height / 2 else {

            dispatcher?.add(event: StopMovingEvent(on: event.playerId))
            return
        }

        playerSystem.setCanJump(to: event.playerId, canJump: true)
        playerSystem.setCanMove(to: event.playerId, canMove: true)
    }

    private func handlePlayerToolContactEvent(event: PlayerToolContactEvent) {
        dispatcher?.add(event: RemoveEvent(on: event.toolId))
    }
}
