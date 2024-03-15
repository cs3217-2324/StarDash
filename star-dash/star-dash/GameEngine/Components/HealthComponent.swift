//
//  HealthComponent.swift
//  star-dash
//
//  Created by Lau Rui han on 12/3/24.
//

import Foundation

class HealthComponent: Component {
    var health: Int

    init(id: ComponentId, entityId: EntityId, health: Int) {
        self.health = health
        super.init(id: id, entityId: entityId)
    }

    convenience init(entityId: EntityId, health: Int) {
        self.init(id: UUID(), entityId: entityId, health: health)
    }
}
