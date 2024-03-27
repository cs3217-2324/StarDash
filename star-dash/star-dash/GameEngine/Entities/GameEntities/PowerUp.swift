import Foundation

class PowerUp: Entity {
    let id: EntityId
    private let position: CGPoint
    private let sprite: String
    private let size: CGSize
    private let type: String

    init(id: EntityId, position: CGPoint, sprite: String, size: CGSize, type: String) {
        self.id = id
        self.position = position
        self.sprite = sprite
        self.type = type
    }

    convenience init(position: CGPoint, sprite: String, size: CGSize, type: String) {
        self.init(id: UUID(), position: position, sprite: sprite, size: size, type: type)
    }

    func setUpAndAdd(to: EntityManager) {
        let positionComponent = PositionComponent(entityId: self.id, position: self.position, rotation: .zero)
        let physicsComponent = PhysicsComponent(entityId: self.id, size: self.size)
        let spriteComponent = SpriteComponent(entityId: self.id,
                                              image: self.sprite,
                                              textureSet: nil,
                                              textureAtlas: nil,
                                              size: self.size)
        physicsComponent.categoryBitMask = PhysicsConstants.CollisionCategory.powerUp
        physicsComponent.contactTestMask = PhysicsConstants.contactTestMask.powerUp
        physicsComponent.collisionBitMask = PhysicsConstants.CollisionMask.powerUp
        physicsComponent.isDynamic = false
        physicsComponent.affectedByGravity = false
        to.add(entity: self)
        to.add(component: positionComponent)
        to.add(component: physicsComponent)
        to.add(component: spriteComponent)
    }
}
