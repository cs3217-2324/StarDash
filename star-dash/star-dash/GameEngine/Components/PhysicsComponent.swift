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
    var collisionMask: UInt32?
    var affectedByGravity = false
    var size: CGSize?

    init(id: ComponentId, entityId: EntityId, size: CGSize) {
        self.shape = .rectangle
        self.size = size
        super.init(id: id, entityId: entityId)
    }

    convenience init(entityId: EntityId, size: CGSize) {
        self.init(id: UUID(), entityId: entityId, size: size)
    }
}

extension PhysicsComponent {
    enum Shape {
        case rectangle
    }
}
