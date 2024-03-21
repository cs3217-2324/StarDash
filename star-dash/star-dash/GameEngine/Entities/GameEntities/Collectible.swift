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

    init(id: EntityId, position: CGPoint, sprite: String, points: Int) {
        self.id = id
        self.position = position
        self.sprite = sprite
        self.points = points
    }

    convenience init(position: CGPoint, sprite: String, points: Int) {
        self.init(id: UUID(), position: position, sprite: sprite, points: points)
    }

    func setUpAndAdd(to: EntityManager) {
        let positionComponent = PositionComponent(entityId: self.id, position: self.position, rotation: .zero)
        let physicsComponent = PhysicsComponent(entityId: self.id, size: PhysicsConstants.Dimensions.collectible)
        physicsComponent.affectedByGravity = false
        physicsComponent.collisionBitMask = PhysicsConstants.CollisionMask.collectible
        let spriteComponent = SpriteComponent(image: sprite, textureAtlas: nil, size: nil)

        to.add(entity: self)
        to.add(component: positionComponent)
        to.add(component: physicsComponent)
        to.add(component: spriteComponent)
    }

    public static func createCoinCollectible(position: CGPoint) -> Collectible {
        return Collectible(position: position, sprite: "Coin", points: 10)
    }
}
