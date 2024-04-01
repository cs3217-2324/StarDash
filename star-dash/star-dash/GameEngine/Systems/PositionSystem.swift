//
//  PositionSystem.swift
//  star-dash
//
//  Created by Ho Jun Hao on 13/3/24.
//

import Foundation

class PositionSystem: System {
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

    func move(entityId: EntityId, to newPosition: CGPoint) {
        guard let positionComponent = getPositionComponent(of: entityId) else {
            return
        }

        positionComponent.setPosition(position: newPosition)
    }

    func rotate(entityId: EntityId, to newRotation: CGFloat) {
        guard let positionComponent = getPositionComponent(of: entityId) else {
            return
        }

        positionComponent.setRotation(rotation: newRotation)
    }

    func getPosition(of entityId: EntityId) -> CGPoint? {
        guard let positionComponent = getPositionComponent(of: entityId) else {
            return nil
        }

        return positionComponent.position
    }

    func setup() {
        dispatcher?.registerListener(self)

        eventHandlers[ObjectIdentifier(TeleportEvent.self)] = { event in
            if let teleportEvent = event as? TeleportEvent {
                self.handleTeleportEvent(event: teleportEvent)
            }
        }
    }

    private func handleTeleportEvent(event: TeleportEvent) {
        move(entityId: event.entityId, to: event.destination)
    }

    private func getPositionComponent(of entityId: EntityId) -> PositionComponent? {
        entityManager.component(ofType: PositionComponent.self, of: entityId)
    }
}
