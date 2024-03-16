//
//  Obstacle.swift
//  star-dash
//
//  Created by Lau Rui han on 12/3/24.
//

import Foundation

class Obstacle: Entity {
    let id: EntityId
    private let position: CGPoint

    init(id: EntityId = UUID(), position: CGPoint) {
        self.id = id
        self.position = position
    }

    func setUpAndAdd(to: EntityManager) {
        let positionComponent = PositionComponent(entityId: self.id, position: self.position, rotation: .zero)
        let physicsComponent =  PhysicsComponent(entityId: self.id, size: PhysicsConstants.Dimensions.obstacle)
        physicsComponent.collisionMask = PhysicsConstants.CollisionMask.obstacle

        to.add(entity: self)
        to.add(component: positionComponent)
        to.add(component: physicsComponent)
    }
}
