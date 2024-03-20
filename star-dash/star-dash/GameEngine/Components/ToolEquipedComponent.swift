//
//  ToolEquipedComponent.swift
//  star-dash
//
//  Created by Ho Jun Hao on 18/3/24.
//

import Foundation

class ToolEquipedComponent: Component {
    var toolId: EntityId

    init(id: ComponentId, entityId: EntityId, toolId: EntityId) {
        self.toolId = toolId
        super.init(id: id, entityId: entityId)
    }

    convenience init(entityId: EntityId, toolId: EntityId) {
        self.init(id: UUID(), entityId: entityId, toolId: toolId)
    }
}
