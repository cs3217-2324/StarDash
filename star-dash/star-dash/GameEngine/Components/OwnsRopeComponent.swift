//
//  RopeComponent.swift
//  star-dash
//
//  Created by Ho Jun Hao on 29/3/24.
//

import Foundation

class OwnsRopeComponent: Component {
    var ropeId: EntityId

    init(id: ComponentId, entityId: EntityId, ropeId: EntityId) {
        self.ropeId = ropeId
        super.init(id: id, entityId: entityId)
    }

    convenience init(entityId: EntityId, ropeId: EntityId) {
        self.init(id: UUID(), entityId: entityId, ropeId: ropeId)
    }
}
