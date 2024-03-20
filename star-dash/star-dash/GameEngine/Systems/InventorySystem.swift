//
//  InventorySystem.swift
//  star-dash
//
//  Created by Ho Jun Hao on 18/3/24.
//

import Foundation

class InventorySystem: System {
    var isActive: Bool
    var dispatcher: EventModifiable?
    var entityManager: EntityManager

    init(_ entityManager: EntityManager, dispatcher: EventModifiable? = nil) {
        self.isActive = true
        self.entityManager = entityManager
        self.dispatcher = dispatcher
    }

    func enqueueItem(for entityId: EntityId, with powerupEntityId: EntityId) {
        guard let inventoryComponent = getInventoryComponent(of: entityId) else {
            return
        }

        inventoryComponent.inventory.append(powerupEntityId)
    }

    func dequeueItem(for entityId: EntityId) -> EntityId? {
        guard let inventoryComponent = getInventoryComponent(of: entityId) else {
            return nil
        }

        return inventoryComponent.inventory.removeFirst()
    }

    private func getInventoryComponent(of entityId: EntityId) -> InventoryComponent? {
        entityManager.component(ofType: InventoryComponent.self, of: entityId)
    }
}
