//
//  Player.swift
//  star-dash
//
//  Created by Lau Rui han on 12/3/24.
//

import Foundation
class Player: Entity {
    let id: EntityId
    private let position: CGPoint
    private let playerSprite: PlayerSprite
    init(id: EntityId, position: CGPoint, playerSprite: PlayerSprite) {
        self.id = id
        self.position = position
        self.playerSprite = playerSprite
    }
    
    convenience init(position: CGPoint, playerSprite: PlayerSprite) {
        self.init(id: UUID(), position: position, playerSprite: playerSprite)
    }
    
    
    func setUpAndAdd(to: EntityManager) {
        let positionComponent = PositionComponent(entityId: self.id, position: self.position, rotation: .zero)
        let healthComponent = HealthComponent(entityId: self.id, health: 100)
        let physicsComponent = PhysicsComponent(
            entityId: self.id,
            mass: .zero,
            velocity: .zero,
            force: .zero,
            collisionMask: PhysicsConstants.CollisionMask.playerCollisionMask,
            affectedByGravity: true)
        
        let spriteComponent = SpriteComponent(entityId: self.id, image: "", size: .zero)
        
        to.add(entity: self)
        to.add(component: positionComponent)
        to.add(component: healthComponent)
        to.add(component: physicsComponent)
        to.add(component: spriteComponent)
    }
}
