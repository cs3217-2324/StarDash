import Foundation

class SpeedBoostPowerUpSystem: System {
    var isActive: Bool
    var dispatcher: EventModifiable?
    var entityManager: EntityManager
    var eventHandlers: [ObjectIdentifier: (Event) -> Void] = [:]

    init(_ entityManager: EntityManager, dispatcher: EventModifiable? = nil) {
        self.isActive = true
        self.entityManager = entityManager
        self.dispatcher = dispatcher
    }

    func setup() {}

    func update(by deltaTime: TimeInterval) {
        for speedBoostComponent in entityManager.components(ofType: SpeedBoostComponent.self) {
            if !speedBoostComponent.isActivated && speedBoostComponent.duration > 0 {
                activatePowerUp(component: speedBoostComponent)
                continue
            }

            speedBoostComponent.duration -= Float(deltaTime)
            if speedBoostComponent.duration <= 0 {
                deactivatePowerUp(component: speedBoostComponent)
            }
        }
    }

    private func activatePowerUp(component: SpeedBoostComponent) {
        guard let buffSystem = dispatcher?.system(ofType: BuffSystem.self),
              !component.isActivated else {
            return
        }

        buffSystem.applySpeedMultiplier(component.multiplier, for: component.entityId)
        component.isActivated = true
    }

    private func deactivatePowerUp(component: SpeedBoostComponent) {
        guard let buffSystem = dispatcher?.system(ofType: BuffSystem.self),
              component.isActivated else {
            return
        }

        component.isActivated = false
        buffSystem.applySpeedMultiplier(1 / component.multiplier, for: component.entityId)
    }
}
