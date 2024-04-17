//
//  RemovalSystem.swift
//  star-dash
//
//  Created by Ho Jun Hao on 26/3/24.
//

import Foundation

class RemovalSystem: System {
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
    }

    private func handleRemoveEvent(event: RemoveEvent) {
        entityManager.remove(entityId: event.entityId)
    }
}
