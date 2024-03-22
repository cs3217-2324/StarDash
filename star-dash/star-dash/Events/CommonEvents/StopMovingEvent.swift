import Foundation

class StopMoving: Event {
    let timestamp: Date
    let entityId: EntityId

    init(on entityId: EntityId) {
        timestamp = Date.now
        self.entityId = entityId
    }

    func execute(on target: EventModifiable) {
        guard let physicsComponent = target.component(ofType: PhysicsComponent.self, ofEntity: entityId),
              let spriteComponent = target.component(ofType: SpriteComponent.self, ofEntity: entityId),
              let textureSet = spriteComponent.textureSet else {
            return
        }

        physicsComponent.velocity = 0
        spriteComponent.textureAtlas = nil
    }
}
