//
//  PhysicsComponent.swift
//  star-dash
//
//  Created by Lau Rui han on 12/3/24.
//

import Foundation

class PhysicsComponent: Component {
    var shape: Shape
    var mass = CGFloat(10)
    var velocity: CGVector = .zero
    var force: CGVector = .zero
    var categoryBitMask: UInt32 = 0xFFFFFFFF
    var contactTestMask: UInt32 = 0x0
    var collisionBitMask: UInt32 = 0xFFFFFFFF
    var isDynamic = true
    var affectedByGravity = false
    var restitution: CGFloat = 0.2
    var size: CGSize?
    var radius: CGFloat?
    var linearDamping: CGFloat = 0.1
    var impulse: CGVector = .zero
    init(entityId: EntityId, rectangleOf size: CGSize) {
        self.shape = .rectangle
        self.size = size
        super.init(id: UUID(), entityId: entityId)
    }

    init(entityId: EntityId, circleOf radius: CGFloat) {
        self.shape = .circle
        self.radius = radius
        super.init(id: UUID(), entityId: entityId)
    }
}

extension PhysicsComponent {
    enum Shape {
        case rectangle
        case circle
    }
}
