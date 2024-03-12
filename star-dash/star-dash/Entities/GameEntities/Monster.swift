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
    
    init(id: EntityId, position: CGPoint) {
        self.id = id
        self.position = position
    }
    
    convenience init(position: CGPoint) {
        self.init(id: UUID(), position: position)
    }
    
    
    func setUpAndAdd(to: EntityManager) {
        let positionComponent = PositionComponent(entityId: self.id, position: self.position, rotation: .zero)
        let healthComponent = HealthComponent(entityId: self.id, health: 100)
        let physicsComponent = PhysicsComponent(
            entityId: self.id,
            mass: .zero,
            velocity: .zero,
            force: .zero,
            collisionMask: PhysicsConstants.CollisionMask.monsterCollisionMask,
            affectedByGravity: false)
        
        
        to.add(entity: self)
        to.add(component: positionComponent)
        to.add(component: healthComponent)
        to.add(component: physicsComponent)
    }
}
