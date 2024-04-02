//
//  GrappleHookOwnerComponent.swift
//  star-dash
//
//  Created by Ho Jun Hao on 28/3/24.
//

import Foundation

class GrappleHookOwnerComponent: Component {
    var ownerPlayerId: EntityId

    init(id: ComponentId, entityId: EntityId, ownerPlayerId: EntityId) {
        self.ownerPlayerId = ownerPlayerId
        super.init(id: id, entityId: entityId)
    }

    convenience init(entityId: EntityId, ownerPlayerId: EntityId) {
        self.init(id: UUID(), entityId: entityId, ownerPlayerId: ownerPlayerId)
    }
}
