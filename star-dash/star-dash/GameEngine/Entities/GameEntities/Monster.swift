//
//  Monster.swift
//  star-dash
//
//  Created by Lau Rui han on 12/3/24.
//

import Foundation

class Monster: Entity {
    let id: EntityId
    private let position: CGPoint
    private let health: Int
    private let sprite: String
    private let size: CGSize
    init(id: EntityId, position: CGPoint, health: Int, sprite: String, size: CGSize) {
        self.id = id
        self.position = position
        self.health = health
        self.sprite = sprite
        self.size = size
    }

    convenience init(position: CGPoint, health: Int, sprite: String, size: CGSize) {
        self.init(id: UUID(), position: position, health: health, sprite: sprite, size: size)
    }

    func setUpAndAdd(to: EntityManager) {
        let positionComponent = PositionComponent(entityId: self.id, position: self.position, rotation: .zero)
        let healthComponent = HealthComponent(entityId: self.id, health: self.health)
        let physicsComponent = PhysicsComponent(entityId: self.id, size: PhysicsConstants.Dimensions.monster)
        let spriteComponent = SpriteComponent(entityId: self.id, image: self.sprite, textureSet: nil, textureAtlas: nil, size: self.size)
        physicsComponent.collisionBitMask = PhysicsConstants.CollisionMask.monster
        physicsComponent.affectedByGravity = false

        to.add(entity: self)
        to.add(component: positionComponent)
        to.add(component: healthComponent)
        to.add(component: physicsComponent)
        to.add(component: spriteComponent)
    }
}
