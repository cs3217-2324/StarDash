//
//  PhysicsComponent.swift
//  star-dash
//
//  Created by Lau Rui han on 12/3/24.
//

import Foundation

class PhysicsComponent: Component {
    var shape: Shape
    var mass: CGFloat = .zero
    var velocity: CGVector = .zero
    var force: CGVector = .zero
    var categoryBitMask: UInt32 = 0xFFFFFFFF
    var contactTestMask: UInt32 = 0x0
    var collisionBitMask: UInt32 = 0xFFFFFFFF
    var isDynamic = true
    var affectedByGravity = false
    var restitution: CGFloat = 0.2
    var size: CGSize?
    var startPoint: CGPoint?
    var endPoint: CGPoint?

    init(id: ComponentId, entityId: EntityId, size: CGSize) {
        self.shape = .rectangle
        self.size = size
        super.init(id: id, entityId: entityId)
    }

    convenience init(entityId: EntityId, size: CGSize) {
        self.init(id: UUID(), entityId: entityId, size: size)
    }

    init(id: ComponentId, entityId: EntityId, startPoint: CGPoint, endPoint: CGPoint) {
        self.shape = .line
        self.startPoint = startPoint
        self.endPoint = endPoint
        super.init(id: id, entityId: entityId)
    }

    convenience init(entityId: EntityId, startPoint: CGPoint, endPoint: CGPoint) {
        self.init(id: UUID(), entityId: entityId, startPoint: startPoint, endPoint: endPoint)
    }
}

extension PhysicsComponent {
    enum Shape {
        case rectangle
        case line
    }
}
