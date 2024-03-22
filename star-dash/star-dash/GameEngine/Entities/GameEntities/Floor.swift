//
//  Floor.swift
//  star-dash
//
//  Created by Ho Jun Hao on 16/3/24.
//

import Foundation

class Floor: Entity {
    let id: EntityId
    private let position: CGPoint

    init(id: EntityId, position: CGPoint) {
        self.id = id
        self.position = position
    }

    init(position: CGPoint) {
        self.id = UUID()
        self.position = position
    }

    func setUpAndAdd(to: EntityManager) {
        let positionComponent = PositionComponent(entityId: self.id, position: self.position, rotation: .zero)
        let physicsComponent = PhysicsComponent(entityId: self.id, size: PhysicsConstants.Dimensions.floor)
        physicsComponent.restitution = 0.0
        physicsComponent.isDynamic = false
        physicsComponent.categoryBitMask = PhysicsConstants.CollisionCategory.floor
        physicsComponent.contactTestMask = PhysicsConstants.ContactMask.floor
        physicsComponent.collisionBitMask = PhysicsConstants.CollisionMask.floor

        to.add(entity: self)
        to.add(component: positionComponent)
        to.add(component: physicsComponent)
    }
}
