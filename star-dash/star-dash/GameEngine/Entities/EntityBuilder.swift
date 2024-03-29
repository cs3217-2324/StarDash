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

    func withPhysics(size: CGSize) -> Self {
        let componentType = ObjectIdentifier(PhysicsComponent.self)
        let component = PhysicsComponent(entityId: entityId, size: size)

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

    func addToGame() {
        self.entityManager.add(entity: self.entity)

        self.components.values.forEach { self.entityManager.add(component: $0) }
    }
}
