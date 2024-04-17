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
        dispatcher?.registerListener(self)

        eventHandlers[ObjectIdentifier(RespawnEvent.self)] = { event in
            if let respawanEvent = event as? RespawnEvent {
                self.handleRespawnEvent(event: respawanEvent)
            }
        }
    }

    func hasPlayerFinishedGame(entityId: EntityId) -> Bool? {
        guard isPlayer(entityId: entityId) else {
            return nil
        }
        guard let playerComponent = getPlayerComponent(of: entityId) else {
            return nil
        }
        return playerComponent.hasFinishedGame
    }

    func setHasFinishedGame(of entityId: EntityId, to hasFinishedGame: Bool) {
        guard let playerComponent = getPlayerComponent(of: entityId) else {
            return
        }
        playerComponent.hasFinishedGame = hasFinishedGame
    }

    func isPlayer(entityId: EntityId) -> Bool {
        getPlayerComponent(of: entityId) != nil
    }

    private func handleRespawnEvent(event: RespawnEvent) {
        dispatcher?.add(event: TeleportEvent(on: event.playerId, to: event.newPosition))
    }

    private func getPlayerComponent(of entityId: EntityId) -> PlayerComponent? {
        entityManager.component(ofType: PlayerComponent.self, of: entityId)
    }

    func getPlayerComponent(of playerIndex: Int) -> PlayerComponent? {
        var playerComponents = entityManager.components(ofType: PlayerComponent.self)
        for player in playerComponents where player.playerIndex == playerIndex {
            return player
        }
        return nil
    }

}
