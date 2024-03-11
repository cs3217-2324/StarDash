//
//  Component.swift
//  star-dash
//
//  Created by Lau Rui han on 12/3/24.
//

import Foundation
typealias ComponentId = UUID
class Component {
    var entityId: UUID
    var id: UUID
    
    init(id: UUID, entityId: UUID) {
        self.id = id
        self.entityId = entityId

    }
    
}
