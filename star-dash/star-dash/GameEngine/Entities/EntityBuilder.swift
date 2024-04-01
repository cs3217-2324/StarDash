//
//  EntityBuilder.swift
//  star-dash
//
//  Created by Ho Jun Hao on 28/3/24.
//

import Foundation

class EntityBuilder {
    private var components: [ObjectIdentifier: Component] = [:]
    private let entity: Entity
    private let entityId: EntityId
    private let entityManager: EntityManagerInterface

    init(entity: Entity, entityManager: EntityManagerInterface) {
        self.entityManager = entityManager
        self.entity = entity
        self.entityId = entity.id
    }

    func withPosition(at position: CGPoint) -> Self {
        let componentType = ObjectIdentifier(PositionComponent.self)
        let component = PositionComponent(entityId: entityId, position: position, rotation: .zero)

        self.components[componentType] = component
        return self
    }

    func withPlayer(playerIndex: Int) -> Self {
        let componentType = ObjectIdentifier(PlayerComponent.self)
        let component = PlayerComponent(entityId: entityId, playerIndex: playerIndex)

        self.components[componentType] = component
        return self
    }

    func withHealth(health: Int) -> Self {
        let componentType = ObjectIdentifier(HealthComponent.self)
        let component = HealthComponent(entityId: entityId, health: health)

        self.components[componentType] = component
        return self
    }

    func withSprite(image: String, textureSet: TextureSet?, textureAtlas: String?, size: CGSize?) -> Self {
        let componentType = ObjectIdentifier(SpriteComponent.self)
        let component = SpriteComponent(entityId: entityId,
                                        image: image,
                                        textureSet: textureSet,
                                        textureAtlas: textureAtlas,
                                        size: size)

        self.components[componentType] = component
        return self
    }

    func withSprite(image: String, textureSet: TextureSet?, textureAtlas: String?, radius: CGFloat?) -> Self {
        let componentType = ObjectIdentifier(SpriteComponent.self)
        let component = SpriteComponent(entityId: entityId,
                                        image: image,
                                        textureSet: textureSet,
                                        textureAtlas: textureAtlas,
                                        radius: radius)

        self.components[componentType] = component
        return self
    }

    func withScore(score: Int) -> Self {
        let componentType = ObjectIdentifier(ScoreComponent.self)
        let component = ScoreComponent(entityId: entityId, score: score)

        self.components[componentType] = component
        return self
    }

    func withPoint(points: Int) -> Self {
        let componentType = ObjectIdentifier(PointsComponent.self)
        let component = PointsComponent(entityId: entityId, points: points)

        self.components[componentType] = component
        return self
    }

    func withPhysics(rectangleOf size: CGSize) -> Self {
        let componentType = ObjectIdentifier(PhysicsComponent.self)
        let component = PhysicsComponent(entityId: entityId, rectangleOf: size)

        self.components[componentType] = component
        return self
    }

    func withPhysics(circleOf radius: CGFloat) -> Self {
        let componentType = ObjectIdentifier(PhysicsComponent.self)
        let component = PhysicsComponent(entityId: entityId, circleOf: radius)

        self.components[componentType] = component
        return self
    }

    func configureCategoryBitMask(_ categoryBitMask: UInt32) -> Self {
        let componentType = ObjectIdentifier(PhysicsComponent.self)

        guard let physicsComponent = self.components[componentType] as? PhysicsComponent else {
            return self
        }

        physicsComponent.categoryBitMask = categoryBitMask
        return self
    }

    func configureContactTestMask(_ contactTestMask: UInt32) -> Self {
        let componentType = ObjectIdentifier(PhysicsComponent.self)

        guard let physicsComponent = self.components[componentType] as? PhysicsComponent else {
            return self
        }

        physicsComponent.contactTestMask = contactTestMask
        return self
    }

    func configureCollisionBitMask(_ collisionBitMask: UInt32) -> Self {
        let componentType = ObjectIdentifier(PhysicsComponent.self)

        guard let physicsComponent = self.components[componentType] as? PhysicsComponent else {
            return self
        }

        physicsComponent.collisionBitMask = collisionBitMask
        return self
    }

    func configureAffectedByGravity(_ affectedByGravity: Bool) -> Self {
        let componentType = ObjectIdentifier(PhysicsComponent.self)

        guard let physicsComponent = self.components[componentType] as? PhysicsComponent else {
            return self
        }

        physicsComponent.affectedByGravity = affectedByGravity
        return self
    }

    func configureRestitution(_ restitution: CGFloat) -> Self {
        let componentType = ObjectIdentifier(PhysicsComponent.self)

        guard let physicsComponent = self.components[componentType] as? PhysicsComponent else {
            return self
        }

        physicsComponent.restitution = restitution
        return self
    }

    func configureIsDynamic(_ isDynamic: Bool) -> Self {
        let componentType = ObjectIdentifier(PhysicsComponent.self)

        guard let physicsComponent = self.components[componentType] as? PhysicsComponent else {
            return self
        }

        physicsComponent.isDynamic = isDynamic
        return self
    }

    func configureLinearDamping(_ linearDamping: CGFloat) -> Self {
        let componentType = ObjectIdentifier(PhysicsComponent.self)

        guard let physicsComponent = self.components[componentType] as? PhysicsComponent else {
            return self
        }

        physicsComponent.linearDamping = linearDamping
        return self
    }
    func withPowerUpType(type: String) -> Self {
        let componentType = ObjectIdentifier(PowerUpComponent.self)
        let component = PowerUpComponent(entityId: entityId, type: type)

        self.components[componentType] = component
        return self
    }

    func withSpeedBoost(entityId: EntityId, duration: Float, multiplier: CGFloat) -> Self {
        let componentType = ObjectIdentifier(SpeedBoostComponent.self)
        let component = SpeedBoostComponent(entityId: entityId, duration: duration, multiplier: multiplier)

        self.components[componentType] = component
        return self
    }

    func withHomingMissle(impulse: CGVector) -> Self {
        let componentType = ObjectIdentifier(HomingMissileComponent.self)
        let component = HomingMissileComponent(entityId: entityId, targetId: nil, impulse: impulse)

        self.components[componentType] = component
        return self
    }

    func addToGame() {
        self.entityManager.add(entity: self.entity)

        self.components.values.forEach { self.entityManager.add(component: $0) }
    }
}
