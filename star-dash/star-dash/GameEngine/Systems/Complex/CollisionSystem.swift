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
        eventHandlers[ObjectIdentifier(GrappleHookObstacleContactEvent.self)] = { event in
            if let grappleHookObstacleContactEvent = event as? GrappleHookObstacleContactEvent {
                self.handleGrappleHookObstacleContactEvent(event: grappleHookObstacleContactEvent)
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

        if let hookOwnerComponent = entityManager
                                    .components(ofType: GrappleHookOwnerComponent.self)
                                    .first(where: { $0.ownerPlayerId == event.playerId }) {
            dispatcher?.add(event: ReleaseGrappleHookEvent(using: hookOwnerComponent.entityId))
        }
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

        if let hookOwnerComponent = entityManager
                                    .components(ofType: GrappleHookOwnerComponent.self)
                                    .first(where: { $0.ownerPlayerId == event.playerId }) {
            dispatcher?.add(event: ReleaseGrappleHookEvent(using: hookOwnerComponent.entityId))
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
              let obstaclePosition = positionSystem.getPosition(of: event.obstacleId),
              playerPosition.y - PhysicsConstants.Dimensions.player.height / 2 >
              obstaclePosition.y + PhysicsConstants.Dimensions.obstacle.height / 2 else {

            dispatcher?.add(event: StopMovingEvent(on: event.playerId))
            return
        }

        playerSystem.setCanJump(to: event.playerId, canJump: true)
        playerSystem.setCanMove(to: event.playerId, canMove: true)

        if let hookOwnerComponent = entityManager
                                    .components(ofType: GrappleHookOwnerComponent.self)
                                    .first(where: { $0.ownerPlayerId == event.playerId }) {
            dispatcher?.add(event: ReleaseGrappleHookEvent(using: hookOwnerComponent.entityId))
        }
    }

    private func handleGrappleHookObstacleContactEvent(event: GrappleHookObstacleContactEvent) {
        guard let hookSystem = dispatcher?.system(ofType: GrappleHookSystem.self),
              let hookState = hookSystem.getHookState(of: event.grappleHookId) else {
            return
        }

        if hookState == .shooting && hookSystem.length(of: event.grappleHookId) >= GameConstants.Hook.minLength {
            hookSystem.setHookState(of: event.grappleHookId, to: .retracting)
        }
    }
}
