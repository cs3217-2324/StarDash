//
//  PositionComponent.swift
//  star-dash
//
//  Created by Lau Rui han on 12/3/24.
//

import Foundation

class PositionComponent: Component {
    var position: CGPoint
    var rotation: Float

    init(id: UUID = UUID(), entityId: UUID, position: CGPoint, rotation: Float) {
        self.position = position
        self.rotation = rotation
        super.init(id: id, entityId: entityId)
    }

    func setPosition(position: CGPoint) {
        self.position = position
    }

    func setRotation(rotation: Float) {
        self.rotation = rotation
    }
}
