//
//  Component.swift
//  star-dash
//
//  Created by Lau Rui han on 12/3/24.
//

import Foundation
typealias ComponentId = UUID
class Component {
    var entityId: EntityId
    var id: ComponentId
    
    init(id: ComponentId, entityId: EntityId) {
        self.id = id
        self.entityId = entityId

    }
    
}
