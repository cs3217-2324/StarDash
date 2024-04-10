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

    // MARK: Death related methods

    func isPlayer(entityId: EntityId) -> Bool {
        getPlayerComponent(of: entityId) != nil
    }

    private func handleRespawnEvent(event: RespawnEvent) {
        dispatcher?.add(event: TeleportEvent(on: event.playerId, to: event.newPosition))
    }

    private func getPlayerComponent(of entityId: EntityId) -> PlayerComponent? {
        entityManager.component(ofType: PlayerComponent.self, of: entityId)
    }
}
