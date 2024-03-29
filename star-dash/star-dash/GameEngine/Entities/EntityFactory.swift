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
                                   position: CGPoint) {
        let playerBuilder = EntityBuilder(entity: Player(id: UUID()), entityManager: entityManager)

        playerBuilder
            .withPlayer(playerIndex: playerIndex)
            .withPosition(at: position)
            .withHealth(health: GameConstants.InitialHealth.player)
            .withSprite(image: SpriteConstants.PlayerRedNose,
                        textureSet: SpriteConstants.PlayerRedNoseTexture,
                        textureAtlas: nil,
                        size: PhysicsConstants.Dimensions.player)
            .withScore(score: 0)
            .withPhysics(size: PhysicsConstants.Dimensions.player)
                .configureCategoryBitMask(PhysicsConstants.CollisionCategory.player)
                .configureContactTestMask(PhysicsConstants.ContactMask.player)
                .configureCollisionBitMask(PhysicsConstants.CollisionMask.player)
                .configureAffectedByGravity(true)
                .configureRestitution(0.0)
            .addToGame()
    }

    static func createAndAddMonster(to entityManager: EntityManagerInterface,
                                    position: CGPoint,
                                    health: Int,
                                    size: CGSize) {
        let monsterBuilder = EntityBuilder(entity: Monster(id: UUID()), entityManager: entityManager)

        monsterBuilder
            .withPosition(at: position)
            .withHealth(health: health)
            .withSprite(image: SpriteConstants.monster,
                        textureSet: nil,
                        textureAtlas: nil,
                        size: size)
            .withPhysics(size: PhysicsConstants.Dimensions.monster)
                .configureCollisionBitMask(PhysicsConstants.CollisionMask.monster)
            .addToGame()
    }

    static func createAndAddCollectible(to entityManager: EntityManagerInterface,
                                        position: CGPoint,
                                        points: Int,
                                        size: CGSize) {
        let collectibleBuilder = EntityBuilder(entity: Collectible(id: UUID()), entityManager: entityManager)

        collectibleBuilder
            .withPosition(at: position)
            .withSprite(image: SpriteConstants.star,
                        textureSet: nil,
                        textureAtlas: nil,
                        size: size)
            .withPoint(points: points)
            .withPhysics(size: size)
                .configureCategoryBitMask(PhysicsConstants.CollisionCategory.collectible)
                .configureContactTestMask(PhysicsConstants.ContactMask.collectible)
                .configureCollisionBitMask(PhysicsConstants.CollisionMask.collectible)
                .configureAffectedByGravity(false)
                .configureIsDynamic(false)
            .addToGame()
    }

    static func createAndAddObstacle(to entityManager: EntityManagerInterface,
                                     position: CGPoint,
                                     size: CGSize) {
        let obstacleBuilder = EntityBuilder(entity: Obstacle(id: UUID()), entityManager: entityManager)

        obstacleBuilder
            .withPosition(at: position)
            .withSprite(image: SpriteConstants.obstacle,
                        textureSet: nil,
                        textureAtlas: nil,
                        size: size)
            .withPhysics(size: size)
                .configureCollisionBitMask(PhysicsConstants.CollisionMask.obstacle)
                .configureIsDynamic(false)
            .addToGame()
    }

    static func createAndAddTool(to entityManager: EntityManagerInterface,
                                 position: CGPoint,
                                 size: CGSize) {
        let toolBuilder = EntityBuilder(entity: Tool(id: UUID()), entityManager: entityManager)

        toolBuilder
            .withPosition(at: position)
            .withSprite(image: SpriteConstants.tool,
                        textureSet: nil,
                        textureAtlas: nil,
                        size: size)
            .withPhysics(size: size)
                .configureCollisionBitMask(PhysicsConstants.CollisionMask.tool)
                .configureIsDynamic(false)
            .addToGame()
    }

    static func createAndAddWall(to entityManager: EntityManagerInterface, position: CGPoint, size: CGSize) {
        let wallBuilder = EntityBuilder(entity: Wall(id: UUID()), entityManager: entityManager)

        wallBuilder
            .withPosition(at: position)
            .withPhysics(size: size)
                .configureCollisionBitMask(PhysicsConstants.CollisionMask.wall)
            .addToGame()
    }

    static func createAndAddFloor(to entityManager: EntityManagerInterface, position: CGPoint, size: CGSize) {
        let floorBuilder = EntityBuilder(entity: Floor(id: UUID()), entityManager: entityManager)

        floorBuilder
            .withPosition(at: position)
            .withPhysics(size: size)
                .configureCategoryBitMask(PhysicsConstants.CollisionCategory.floor)
                .configureContactTestMask(PhysicsConstants.ContactMask.floor)
                .configureCollisionBitMask(PhysicsConstants.CollisionMask.floor)
                .configureIsDynamic(false)
                .configureRestitution(0.0)
            .addToGame()
    }
}
