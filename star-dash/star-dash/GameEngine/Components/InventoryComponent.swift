//
//  InventoryComponent.swift
//  star-dash
//
//  Created by Ho Jun Hao on 18/3/24.
//

import Foundation

class InventoryComponent: Component {
    var inventory: [EntityId]

    init(id: ComponentId, entityId: EntityId, inventory: [EntityId]) {
        self.inventory = inventory
        super.init(id: id, entityId: entityId)
    }

    convenience init(entityId: EntityId) {
        self.init(id: UUID(), entityId: entityId, inventory: [])
    }
}
