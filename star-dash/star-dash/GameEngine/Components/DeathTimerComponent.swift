//
//  DeathTimerComponent.swift
//  star-dash
//
//  Created by Ho Jun Hao on 10/4/24.
//

import Foundation

class DeathTimerComponent: Component {
    var deathTimer: Double = 0

    override init(id: ComponentId, entityId: EntityId) {
        super.init(id: id, entityId: entityId)
    }

    convenience init(entityId: EntityId) {
        self.init(id: UUID(), entityId: entityId)
    }
}
