//
//  Player.swift
//  star-dash
//
//  Created by Lau Rui han on 12/3/24.
//

import Foundation

class Player: Entity {
    let id: EntityId
    private let playerIndex: Int
    private let position: CGPoint
    private let playerSprite: PlayerSprite

    init(id: EntityId, playerIndex: Int, position: CGPoint, playerSprite: PlayerSprite) {
        self.id = id
        self.playerIndex = playerIndex
        self.position = position
        self.playerSprite = playerSprite
    }

    convenience init(playerIndex: Int, position: CGPoint, playerSprite: PlayerSprite) {
        self.init(id: UUID(), playerIndex: playerIndex, position: position, playerSprite: playerSprite)
    }

    func setUpAndAdd(to: EntityManager) {
        let playerComponent = PlayerComponent(entityId: self.id, playerIndex: playerIndex)
        let positionComponent = PositionComponent(entityId: self.id, position: self.position, rotation: .zero)
        let healthComponent = HealthComponent(entityId: self.id, health: GameConstants.InitialHealth.player)
        let physicsComponent = PhysicsComponent(entityId: self.id, size: PhysicsConstants.Dimensions.player)
        physicsComponent.categoryBitMask = PhysicsConstants.CollisionCategory.player
        physicsComponent.contactTestMask = PhysicsConstants.ContactMask.player
        physicsComponent.collisionBitMask = PhysicsConstants.CollisionMask.player
        physicsComponent.affectedByGravity = true
        physicsComponent.restitution = 0.0
        let spriteComponent = SpriteComponent(
            entityId: self.id,
            image: SpriteConstants.PlayerRedNose.stand,
            textureAtlas: nil,
            size: CGSize(width: 100, height: 140)
        )
        let scoreComponent = ScoreComponent(entityId: self.id, score: 0)

        to.add(entity: self)
        to.add(component: playerComponent)
        to.add(component: positionComponent)
        to.add(component: healthComponent)
        to.add(component: physicsComponent)
        to.add(component: spriteComponent)
        to.add(component: scoreComponent)
    }
}
