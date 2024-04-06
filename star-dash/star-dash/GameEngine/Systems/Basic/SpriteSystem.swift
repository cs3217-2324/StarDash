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
        startAnimation(of: entityId, named: named, repetitive: true, duration: nil)
    }

    func startAnimation(of entityId: EntityId, named: String, repetitive: Bool, duration: Double?) {
        guard let spriteComponent = getSpriteComponent(of: entityId),
              let textureAtlas = spriteComponent.textureSet?.getValueFor(key: named) else {
            return
        }

        spriteComponent.textureAtlas = textureAtlas
        spriteComponent.repetitive = repetitive
        spriteComponent.animationDuration = duration
    }

    func endAnimation(of entityId: EntityId) {
        guard let spriteComponent = getSpriteComponent(of: entityId) else {
            return
        }

        spriteComponent.textureAtlas = nil
    }

    func setSize(of entityId: EntityId, to size: CGSize) {
        guard let spriteComponent = getSpriteComponent(of: entityId) else {
            return
        }

        spriteComponent.size = size
    }

    func setup() {}

    private func getSpriteComponent(of entityId: EntityId) -> SpriteComponent? {
        entityManager.component(ofType: SpriteComponent.self, of: entityId)
    }
}
