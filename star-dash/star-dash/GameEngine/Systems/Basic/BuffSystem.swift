import Foundation

class BuffSystem: System {

    var isActive: Bool
    var dispatcher: EventModifiable?
    var entityManager: EntityManager
    var eventHandlers: [ObjectIdentifier: (Event) -> Void] = [:]

    init(_ entityManager: EntityManager, dispatcher: EventModifiable? = nil) {
        self.isActive = true
        self.entityManager = entityManager
        self.dispatcher = dispatcher
    }

    func speedMultiplier(of entityId: EntityId) -> CGFloat? {
        guard let buffComponent = getBuffComponent(of: entityId) else {
            return nil
        }

        return buffComponent.speedMultiplier
    }

    func applySpeedMultiplier(_ multiplier: CGFloat, for entityId: EntityId) {
        if getBuffComponent(of: entityId) == nil {
           setupBuffComponent(for: entityId)
        }

        guard let buffComponent = getBuffComponent(of: entityId),
              multiplier != 0 else {
            return
        }

        buffComponent.speedMultiplier *= multiplier
    }

    func setup() {}

    private func setupBuffComponent(for entityId: EntityId) {
        let buffComponent = BuffComponent(entityId: entityId)
        entityManager.add(component: buffComponent)
    }

    private func getBuffComponent(of entityId: EntityId) -> BuffComponent? {
        entityManager.component(ofType: BuffComponent.self, of: entityId)
    }
}
