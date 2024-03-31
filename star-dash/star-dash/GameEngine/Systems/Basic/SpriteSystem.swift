import Foundation

class SpriteSystem: System {
    var isActive: Bool
    var dispatcher: EventModifiable?
    var entityManager: EntityManager
    var eventHandlers: [ObjectIdentifier: (Event) -> Void] = [:]

    init(_ entityManager: EntityManager, dispatcher: EventModifiable? = nil) {
        self.isActive = true
        self.entityManager = entityManager
        self.dispatcher = dispatcher
        setup()
    }

    func startAnimation(of entityId: EntityId, named: String) {
        guard let spriteComponent = getSpriteComponent(of: entityId),
              let keyPath = \TextureSet.self[named],
              let textureAtlas = spriteComponent.textureSet?[keyPath: keyPath] else {
            return
        }

        spriteComponent.textureAtlas = textureAtlas
    }

    func endAnimation(of entityId: EntityId) {
        guard let spriteComponent = getSpriteComponent(of: entityId) else {
            return
        }

        spriteComponent.textureAtlas = nil
    }

    func setup() {}

    private func getSpriteComponent(of entityId: EntityId) -> SpriteComponent? {
        entityManager.component(ofType: SpriteComponent.self, of: entityId)
    }
}
