//
//  Collectible.swift
//  star-dash
//
//  Created by Lau Rui han on 12/3/24.
//

import Foundation

class Collectible: Entity {
    let id: EntityId
    private let position: CGPoint
    private let sprite: String
    private let points: Int
    private let size: CGSize

    init(id: EntityId, position: CGPoint, sprite: String, points: Int, size: CGSize) {
        self.id = id
        self.position = position
        self.sprite = sprite
        self.points = points
        self.size = size
    }

    convenience init(position: CGPoint, sprite: String, points: Int, size: CGSize) {
        self.init(id: UUID(), position: position, sprite: sprite, points: points, size: size)
    }

    func addComponents(to: EntityManager) {
        let positionComponent = PositionComponent(entityId: self.id, position: self.position, rotation: .zero)
        let spriteComponent = SpriteComponent(
            entityId: self.id,
            image: sprite,
            textureSet: nil,
            textureAtlas: nil,
            size: size
        )
        let pointsComponent = PointsComponent(entityId: self.id, points: points)
        let physicsComponent = PhysicsComponent(entityId: self.id, size: self.size)
        physicsComponent.affectedByGravity = false
        physicsComponent.isDynamic = false
        physicsComponent.categoryBitMask = PhysicsConstants.CollisionCategory.collectible
        physicsComponent.contactTestMask = PhysicsConstants.ContactMask.collectible
        physicsComponent.collisionBitMask = PhysicsConstants.CollisionMask.collectible

        to.add(component: positionComponent)
        to.add(component: physicsComponent)
        to.add(component: spriteComponent)
        to.add(component: pointsComponent)
    }

    static func createStarCollectible(position: CGPoint) -> Collectible {
        Collectible(
            position: position,
            sprite: SpriteConstants.star,
            points: EntityConstants.StarCollectible.points,
            size: EntityConstants.StarCollectible.size
        )
    }
}
