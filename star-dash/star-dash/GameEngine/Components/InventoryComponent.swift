//
//  InventoryComponent.swift
//  star-dash
//
//  Created by Ho Jun Hao on 18/3/24.
//

import DequeModule
import Foundation

typealias InventoryQueue = Deque<EntityId>

class InventoryComponent: Component {
    var inventory: Deque<EntityId>

    init(id: ComponentId, entityId: EntityId, inventory: Deque<EntityId>) {
        self.inventory = inventory
        super.init(id: id, entityId: entityId)
    }

    convenience init(entityId: EntityId) {
        self.init(id: UUID(), entityId: entityId, inventory: InventoryQueue())
    }
}
