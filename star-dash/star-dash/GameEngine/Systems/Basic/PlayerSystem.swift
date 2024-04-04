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

        eventHandlers[ObjectIdentifier(RespawnEvent.self)] = { event in
            if let respawanEvent = event as? RespawnEvent {
                self.handleRespawnEvent(event: respawanEvent)
            }
        }
    }

    func canJump(for entityId: EntityId) -> Bool {
        guard let playerComponent = getPlayerComponent(of: entityId) else {
            return false
        }

        return playerComponent.canJump
    }

    func canMove(for entityId: EntityId) -> Bool {
        guard let playerComponent = getPlayerComponent(of: entityId) else {
            return false
        }

        return playerComponent.canMove
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

    func setDeathTimer(to entityId: EntityId, timer: Double) {
        guard let playerComponent = getPlayerComponent(of: entityId) else {
            return
        }

        playerComponent.isDead = timer > 0
        playerComponent.deathTimer = timer
    }

    private func handleRespawnEvent(event: RespawnEvent) {
        dispatcher?.add(event: TeleportEvent(on: event.entityId, to: event.newPosition))
    }

    private func getPlayerComponent(of entityId: EntityId) -> PlayerComponent? {
        entityManager.component(ofType: PlayerComponent.self, of: entityId)
    }
}
