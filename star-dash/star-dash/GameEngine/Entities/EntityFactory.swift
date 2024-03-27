//
//  EntityFactory.swift
//  star-dash
//
//  Created by Ho Jun Hao on 27/3/24.
//

import Foundation

struct EntityFactory {
    static func createAndAddPlayer(to entityManager: EntityManagerInterface,
                                   playerIndex: Int,
                                   position: CGPoint,
                                   sprite: PlayerSprite) {
        let id = UUID()
        let player = Player(id: id)

        let playerComponent = PlayerComponent(entityId: id, playerIndex: playerIndex)
        let positionComponent = PositionComponent(entityId: id, position: position, rotation: .zero)
        let healthComponent = HealthComponent(entityId: id, health: GameConstants.InitialHealth.player)
        let spriteComponent = SpriteComponent(
            entityId: id,
            image: SpriteConstants.PlayerRedNose,
            textureSet: SpriteConstants.PlayerRedNoseTexture,
            textureAtlas: nil,
            size: PhysicsConstants.Dimensions.player
        )
        let scoreComponent = ScoreComponent(entityId: id, score: 0)
        let physicsComponent = PhysicsComponent(entityId: id, size: PhysicsConstants.Dimensions.player)
        physicsComponent.categoryBitMask = PhysicsConstants.CollisionCategory.player
        physicsComponent.contactTestMask = PhysicsConstants.ContactMask.player
        physicsComponent.collisionBitMask = PhysicsConstants.CollisionMask.player
        physicsComponent.affectedByGravity = true
        physicsComponent.restitution = 0.0

        entityManager.add(entity: player)
        entityManager.add(component: playerComponent)
        entityManager.add(component: positionComponent)
        entityManager.add(component: healthComponent)
        entityManager.add(component: physicsComponent)
        entityManager.add(component: spriteComponent)
        entityManager.add(component: scoreComponent)
    }

    static func createAndAddMonster(to entityManager: EntityManagerInterface,
                                    position: CGPoint,
                                    health: Int,
                                    sprite: String,
                                    size: CGSize) {
        let id = UUID()
        let monster = Monster(id: id)

        let positionComponent = PositionComponent(entityId: id, position: position, rotation: .zero)
        let healthComponent = HealthComponent(entityId: id, health: health)
        let spriteComponent = SpriteComponent(entityId: id,
                                              image: sprite,
                                              textureSet: nil,
                                              textureAtlas: nil,
                                              size: size)
        let physicsComponent = PhysicsComponent(entityId: id, size: PhysicsConstants.Dimensions.monster)
        physicsComponent.collisionBitMask = PhysicsConstants.CollisionMask.monster

        entityManager.add(entity: monster)
        entityManager.add(component: positionComponent)
        entityManager.add(component: healthComponent)
        entityManager.add(component: physicsComponent)
        entityManager.add(component: spriteComponent)
    }

    static func createAndAddCollectible(to entityManager: EntityManagerInterface,
                                        position: CGPoint,
                                        sprite: String,
                                        points: Int,
                                        size: CGSize) {
        let id = UUID()
        let collectible = Collectible(id: id)

        let positionComponent = PositionComponent(entityId: id, position: position, rotation: .zero)
        let spriteComponent = SpriteComponent(
            entityId: id,
            image: sprite,
            textureSet: nil,
            textureAtlas: nil,
            size: size
        )
        let pointsComponent = PointsComponent(entityId: id, points: points)
        let physicsComponent = PhysicsComponent(entityId: id, size: size)
        physicsComponent.affectedByGravity = false
        physicsComponent.isDynamic = false
        physicsComponent.categoryBitMask = PhysicsConstants.CollisionCategory.collectible
        physicsComponent.contactTestMask = PhysicsConstants.ContactMask.collectible
        physicsComponent.collisionBitMask = PhysicsConstants.CollisionMask.collectible

        entityManager.add(entity: collectible)
        entityManager.add(component: positionComponent)
        entityManager.add(component: physicsComponent)
        entityManager.add(component: spriteComponent)
        entityManager.add(component: pointsComponent)
    }

    static func createAndAddObstacle(to entityManager: EntityManagerInterface,
                                     position: CGPoint,
                                     sprite: String,
                                     size: CGSize) {
        let id = UUID()
        let obstacle = Obstacle(id: id)

        let positionComponent = PositionComponent(entityId: id, position: position, rotation: .zero)
        let spriteComponent = SpriteComponent(entityId: id,
                                              image: sprite,
                                              textureSet: nil,
                                              textureAtlas: nil,
                                              size: size)
        let physicsComponent = PhysicsComponent(entityId: id, size: size)
        physicsComponent.collisionBitMask = PhysicsConstants.CollisionMask.obstacle
        physicsComponent.isDynamic = false

        entityManager.add(entity: obstacle)
        entityManager.add(component: positionComponent)
        entityManager.add(component: physicsComponent)
        entityManager.add(component: spriteComponent)
    }

    static func createAndAddTool(to entityManager: EntityManagerInterface,
                                 position: CGPoint,
                                 sprite: String,
                                 size: CGSize) {
        let id = UUID()
        let tool = Tool(id: id)

        let positionComponent = PositionComponent(entityId: id, position: position, rotation: .zero)
        let spriteComponent = SpriteComponent(entityId: id,
                                              image: sprite,
                                              textureSet: nil,
                                              textureAtlas: nil,
                                              size: size)
        let physicsComponent = PhysicsComponent(entityId: id, size: size)
        physicsComponent.collisionBitMask = PhysicsConstants.CollisionMask.tool
        physicsComponent.isDynamic = false

        entityManager.add(entity: tool)
        entityManager.add(component: positionComponent)
        entityManager.add(component: physicsComponent)
        entityManager.add(component: spriteComponent)
    }

    static func createAndAddWall(to entityManager: EntityManagerInterface, position: CGPoint, size: CGSize) {
        let id = UUID()
        let wall = Wall(id: id)

        let positionComponent = PositionComponent(entityId: id, position: position, rotation: .zero)
        let physicsComponent = PhysicsComponent(entityId: id, size: PhysicsConstants.Dimensions.wall)
        physicsComponent.collisionBitMask = PhysicsConstants.CollisionMask.wall

        entityManager.add(entity: wall)
        entityManager.add(component: positionComponent)
        entityManager.add(component: physicsComponent)
    }

    static func createAndAddFloor(to entityManager: EntityManagerInterface, position: CGPoint, size: CGSize) {
        let id = UUID()
        let floor = Floor(id: id)

        let positionComponent = PositionComponent(entityId: id, position: position, rotation: .zero)
        let physicsComponent = PhysicsComponent(entityId: id, size: size)
        physicsComponent.restitution = 0.0
        physicsComponent.isDynamic = false
        physicsComponent.categoryBitMask = PhysicsConstants.CollisionCategory.floor
        physicsComponent.contactTestMask = PhysicsConstants.ContactMask.floor
        physicsComponent.collisionBitMask = PhysicsConstants.CollisionMask.floor

        entityManager.add(entity: floor)
        entityManager.add(component: positionComponent)
        entityManager.add(component: physicsComponent)
    }
}
