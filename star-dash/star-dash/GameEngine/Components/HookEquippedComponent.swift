//
//  HookEquippedComponent.swift
//  star-dash
//
//  Created by Ho Jun Hao on 18/3/24.
//

import Foundation

class HookEquippedComponent: Component {
    var hookId: EntityId

    init(id: ComponentId, entityId: EntityId, hookId: EntityId) {
        self.hookId = hookId
        super.init(id: id, entityId: entityId)
    }

    convenience init(entityId: EntityId, hookId: EntityId) {
        self.init(id: UUID(), entityId: entityId, hookId: hookId)
    }
}
