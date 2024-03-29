import Foundation

class BuffSystem: System, EventListener {
    
    var isActive: Bool
    var dispatcher: EventModifiable?
    var entityManager: EntityManager
    var eventHandlers: [ObjectIdentifier: (Event) -> Void] = [:]

    init(_ entityManager: EntityManager, dispatcher: EventModifiable? = nil) {
        self.isActive = true
        self.entityManager = entityManager
        self.dispatcher = dispatcher
    }

    func applySpeedMultiplier(_ multiplier: Float, for entityId: EntityId) {
        guard let buffComponent = getBuffComponent(of: entityId),
              multiplier != 0 else {
            return
        }

        buffComponent.speedMultiplier *= multiplier
    }
    
    func setup() {}

    private func getBuffComponent(of entityId: EntityId) -> BuffComponent? {
        entityManager.component(ofType: BuffComponent.self, of: entityId)
    }
}
