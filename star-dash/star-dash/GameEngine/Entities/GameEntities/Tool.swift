//
//  Tool.swift
//  star-dash
//
//  Created by Lau Rui han on 12/3/24.
//

import Foundation

class Tool: Entity {
    let id: EntityId
    private let position: CGPoint

    init(id: EntityId, position: CGPoint) {
        self.id = id
        self.position = position
    }

    convenience init(position: CGPoint) {
        self.init(id: UUID(), position: position)
    }

    func setUpAndAdd(to: EntityManager) {
        let positionComponent = PositionComponent(entityId: self.id, position: self.position, rotation: .zero)
        let physicsComponent =  PhysicsComponent(entityId: self.id, size: PhysicsConstants.Dimensions.tool)
        physicsComponent.collisionMask = PhysicsConstants.CollisionMask.tool

        to.add(entity: self)
        to.add(component: positionComponent)
        to.add(component: physicsComponent)
    }
}
