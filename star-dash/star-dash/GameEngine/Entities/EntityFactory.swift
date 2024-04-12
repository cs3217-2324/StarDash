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
            .withSprite(image: SpriteConstants.playerRedNose,
                        textureSet: SpriteConstants.playerRedNoseTexture,
                        textureAtlas: nil,
                        size: PhysicsConstants.Dimensions.player)
            .withScore(score: 0)
            .withDeathTimer()
            .withPhysics(rectangleOf: PhysicsConstants.Dimensions.player)
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
                        textureSet: SpriteConstants.monsterTexture,
                        textureAtlas: nil,
                        size: size)
            .withDeathTimer()
            .withPhysics(rectangleOf: size)
                .configureVelocity(CGVector(dx: PhysicsConstants.Monster.moveSpeed, dy: 0))
                .configureCategoryBitMask(PhysicsConstants.CollisionCategory.monster)
                .configureContactTestMask(PhysicsConstants.ContactMask.monster)
                .configureCollisionBitMask(PhysicsConstants.CollisionMask.monster)
                .configureAffectedByGravity(true)
                .configureRestitution(0.0)
            .addToGame()
    }

    static func createAndAddCollectible(to entityManager: EntityManagerInterface,
                                        position: CGPoint,
                                        points: Int,
                                        radius: CGFloat) {
        let collectibleBuilder = EntityBuilder(entity: Collectible(id: UUID()), entityManager: entityManager)

        collectibleBuilder
            .withPosition(at: position)
            .withSprite(image: SpriteConstants.star,
                        textureSet: nil,
                        textureAtlas: nil,
                        radius: radius)
            .withPoint(points: points)
            .withPhysics(circleOf: radius)
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
            .withPhysics(rectangleOf: size)
                .configureCollisionBitMask(PhysicsConstants.CollisionMask.obstacle)
                .configureIsDynamic(false)
            .addToGame()
    }

    static func createAndAddPowerUpBox(to entityManager: EntityManagerInterface,
                                       position: CGPoint,
                                       size: CGSize,
                                       type: String) {
        let powerUpBoxBuilder = EntityBuilder(entity: PowerUpBox(id: UUID()), entityManager: entityManager)

        powerUpBoxBuilder
            .withPosition(at: position)
            .withSprite(image: SpriteConstants.powerUpBox,
                        textureSet: nil,
                        textureAtlas: nil,
                        size: size)
            .withPhysics(rectangleOf: size)
                .configureCategoryBitMask(PhysicsConstants.CollisionCategory.powerUpBox)
                .configureContactTestMask(PhysicsConstants.ContactMask.powerUpBox)
                .configureCollisionBitMask(PhysicsConstants.CollisionMask.powerUpBox)
                .configureIsDynamic(false)
            .withPowerUpType(type: type)
            .addToGame()
    }

    static func createAndAddWall(to entityManager: EntityManagerInterface, position: CGPoint, size: CGSize) {
        let wallBuilder = EntityBuilder(entity: Wall(id: UUID()), entityManager: entityManager)

        wallBuilder
            .withPosition(at: position)
            .withPhysics(rectangleOf: size)
                .configureCategoryBitMask(PhysicsConstants.CollisionCategory.wall)
                .configureContactTestMask(PhysicsConstants.ContactMask.wall)
                .configureCollisionBitMask(PhysicsConstants.CollisionMask.wall)
                .configureIsDynamic(false)
                .configureRestitution(0.0)
            .addToGame()
    }

    static func createAndAddFloor(to entityManager: EntityManagerInterface, position: CGPoint, size: CGSize) {
        let floorBuilder = EntityBuilder(entity: Floor(id: UUID()), entityManager: entityManager)

        floorBuilder
            .withPosition(at: position)
            .withPhysics(rectangleOf: size)
                .configureCategoryBitMask(PhysicsConstants.CollisionCategory.floor)
                .configureContactTestMask(PhysicsConstants.ContactMask.floor)
                .configureCollisionBitMask(PhysicsConstants.CollisionMask.floor)
                .configureIsDynamic(false)
                .configureRestitution(0.0)
            .addToGame()
    }

    static func createAndAddGrappleHook(to entityManager: EntityManagerInterface,
                                        playerId: EntityId,
                                        isLeft: Bool,
                                        startpoint: CGPoint) {
        let ropeId = UUID()
        let ropeBuilder = EntityBuilder(entity: Rope(id: ropeId), entityManager: entityManager)

        ropeBuilder
            .withPosition(at: startpoint)
            .withSprite(image: SpriteConstants.rope,
                        textureSet: nil,
                        textureAtlas: nil,
                        size: .zero)
            .withPhysics(rectangleOf: .zero)
                .configureCategoryBitMask(PhysicsConstants.CollisionCategory.hook)
                .configureContactTestMask(PhysicsConstants.ContactMask.hook)
                .configureCollisionBitMask(PhysicsConstants.CollisionMask.hook)
                .configureIsDynamic(false)
                .configureRestitution(0.0)
                .configureAffectedByGravity(false)
            .addToGame()

        let grappleHookBuilder = EntityBuilder(entity: GrappleHook(id: UUID()), entityManager: entityManager)

        grappleHookBuilder
            .withHookOwner(playerId: playerId)
            .withOwnsRope(ropeId: ropeId)
            .withGrappleHook(at: startpoint, isLeft: isLeft)
            .withPosition(at: startpoint)
            .withSprite(image: SpriteConstants.hook,
                        textureSet: nil,
                        textureAtlas: nil,
                        size: CGSize(width: 20, height: 20))
            .withPhysics(rectangleOf: CGSize(width: 20, height: 20))
                .configureCategoryBitMask(PhysicsConstants.CollisionCategory.hook)
                .configureContactTestMask(PhysicsConstants.ContactMask.hook)
                .configureCollisionBitMask(PhysicsConstants.CollisionMask.hook)
                .configureIsDynamic(true)
                .configureRestitution(0.0)
                .configureAffectedByGravity(false)
            .addToGame()
    }

    static func createAndAddSpeedBoostPowerUp(to entityManager: EntityManagerInterface,
                                              entityId: EntityId,
                                              duration: Float,
                                              multiplier: CGFloat) {
        let powerUpBuilder = EntityBuilder(entity: SpeedBoostPowerUp(id: UUID()), entityManager: entityManager)

        powerUpBuilder
            .withSpeedBoost(entityId: entityId, duration: duration, multiplier: multiplier)
            .addToGame()
    }

    static func createAndAddHomingMissilePowerUp(to entityManager: EntityManagerInterface,
                                                 position: CGPoint,
                                                 impulse: CGVector) {
        let powerUpBuilder = EntityBuilder(entity: HomingMissile(id: UUID()), entityManager: entityManager)

        powerUpBuilder
            .withPosition(at: position)
            .withSprite(image: SpriteConstants.homingMissile,
                        textureSet: nil,
                        textureAtlas: nil,
                        size: PhysicsConstants.Dimensions.homingMissile)
            .withPhysics(rectangleOf: PhysicsConstants.Dimensions.homingMissile)
                .configureCategoryBitMask(PhysicsConstants.CollisionCategory.homingMissile)
                .configureContactTestMask(PhysicsConstants.ContactMask.homingMissile)
                .configureCollisionBitMask(PhysicsConstants.CollisionMask.homingMissile)
                .configureAffectedByGravity(false)
                .configureLinearDamping(0)
            .withHomingMissile(impulse: impulse)
            .addToGame()
    }
}
