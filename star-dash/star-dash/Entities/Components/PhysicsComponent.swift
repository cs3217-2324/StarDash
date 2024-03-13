//
//  PhysicsComponent.swift
//  star-dash
//
//  Created by Lau Rui han on 12/3/24.
//

import Foundation

class PhysicsComponent: Component {
    var mass: CGFloat
    var velocity: CGVector
    var force: CGVector
    var collisionMask: UInt32
    var affectedByGravity: Bool

    init(id: ComponentId, entityId: EntityId, mass: CGFloat, velocity: CGVector,
         force: CGVector, collisionMask: UInt32, affectedByGravity: Bool) {
        self.mass = mass
        self.velocity = velocity
        self.force = force
        self.collisionMask = collisionMask
        self.affectedByGravity = affectedByGravity
        super.init(id: id, entityId: entityId)
    }

    convenience init(entityId: EntityId, mass: CGFloat, velocity: CGVector,
                     force: CGVector, collisionMask: UInt32, affectedByGravity: Bool) {
        self.init(id: UUID(), entityId: entityId, mass: mass, velocity: velocity,
                  force: force, collisionMask: collisionMask, affectedByGravity: affectedByGravity)
    }
}
