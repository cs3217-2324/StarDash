//
//  GrappleHookOwnerComponent.swift
//  star-dash
//
//  Created by Ho Jun Hao on 28/3/24.
//

import Foundation

class GrappleHookOwnerComponent: Component {
    var playerId: EntityId

    init(id: ComponentId, entityId: EntityId, playerId: EntityId) {
        self.playerId = playerId
        super.init(id: id, entityId: entityId)
    }

    convenience init(entityId: EntityId, playerId: EntityId) {
        self.init(id: UUID(), entityId: entityId, playerId: playerId)
    }
}
