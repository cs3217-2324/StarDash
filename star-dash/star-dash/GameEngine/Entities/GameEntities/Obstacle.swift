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
    private let sprite: String
    private let size: CGSize
    init(id: EntityId, position: CGPoint, sprite: String, size: CGSize) {
        self.id = id
        self.position = position
        self.sprite = sprite
        self.size = size
    }

    convenience init(position: CGPoint, sprite: String, size: CGSize) {
        self.init(id: UUID(), position: position, sprite: sprite, size: size)
    }

    func setUpAndAdd(to: EntityManager) {
        let positionComponent = PositionComponent(entityId: self.id, position: self.position, rotation: .zero)
        let physicsComponent = PhysicsComponent(entityId: self.id, size: PhysicsConstants.Dimensions.obstacle)
        physicsComponent.collisionBitMask = PhysicsConstants.CollisionMask.obstacle

        to.add(entity: self)
        to.add(component: positionComponent)
        to.add(component: physicsComponent)
    }
}
