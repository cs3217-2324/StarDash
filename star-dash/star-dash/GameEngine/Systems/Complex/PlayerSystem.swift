//
//  PlayerSystem.swift
//  star-dash
//
//  Created by Ho Jun Hao on 26/3/24.
//

import Foundation

class PlayerSystem: System {
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
        dispatcher?.registerListener(for: RespawnEvent.self, listener: self)
        dispatcher?.registerListener(for: PlayerDeathEvent.self, listener: self)

        eventHandlers[ObjectIdentifier(RespawnEvent.self)] = { event in
            if let respawanEvent = event as? RespawnEvent {
                self.handleRespawnEvent(event: respawanEvent)
            }
        }
        eventHandlers[ObjectIdentifier(PlayerDeathEvent.self)] = { event in
            if let playerDeathEvent = event as? PlayerDeathEvent {
                self.handlePlayerDeathEvent(event: playerDeathEvent)
            }
        }
    }

    func setCanJump(to entityId: EntityId, canJump: Bool) {
        guard let playerComponent = getPlayerComponent(of: entityId) else {
            return
        }

        playerComponent.canJump = canJump
    }

    func setCanMove(to entityId: EntityId, canMove: Bool) {
        guard let playerComponent = getPlayerComponent(of: entityId) else {
            return
        }

        playerComponent.canMove = canMove
    }

    private func handleRespawnEvent(event: RespawnEvent) {
        dispatcher?.add(event: TeleportEvent(on: event.entityId, to: event.newPosition))
    }

    private func handlePlayerDeathEvent(event: PlayerDeathEvent) {
        // TODO
    }

    private func getPlayerComponent(of entityId: EntityId) -> PlayerComponent? {
        entityManager.component(ofType: PlayerComponent.self, of: entityId)
    }
}
