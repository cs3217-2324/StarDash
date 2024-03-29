//
//  PositionComponent.swift
//  star-dash
//
//  Created by Lau Rui han on 12/3/24.
//

import Foundation

class PositionComponent: Component {
    var position: CGPoint
    var rotation: CGFloat

    init(id: UUID, entityId: UUID, position: CGPoint, rotation: CGFloat) {
        self.position = position
        self.rotation = rotation
        super.init(id: id, entityId: entityId)
    }

    convenience init(entityId: UUID, position: CGPoint, rotation: CGFloat) {
        self.init(id: UUID(), entityId: entityId, position: position, rotation: rotation)
    }
}
