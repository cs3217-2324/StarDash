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
    var isFacingLeft: Bool

    init(id: UUID, entityId: UUID, position: CGPoint, rotation: CGFloat, isFacingLeft: Bool) {
        self.position = position
        self.rotation = rotation
        self.isFacingLeft = isFacingLeft
        super.init(id: id, entityId: entityId)
    }

    convenience init(entityId: UUID, position: CGPoint, rotation: CGFloat, isFacingLeft: Bool = false) {
        self.init(id: UUID(), entityId: entityId, position: position, rotation: rotation, isFacingLeft: isFacingLeft)
    }
}
