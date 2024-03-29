import Foundation

class SpeedBoostPowerUpSystem: System, EventListener {
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
        for speedBoostComponent in entityManager.component(ofType: SpeedBoostComponent.self) {
            if !speedBoostComponent.isActivated {
                activatePowerUp(component: speedBoostComponent)
                continue
            }

            speedBoostComponent.duration -= Float(deltaTime)
            if speedBoostComponent.duration <= 0 {
                deactivatePowerUp(component: speedBoostComponent)
                removePowerUp(component: speedBoostComponent)
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

        buffSystem.applySpeedMultiplier(1 / component.multiplier, for: component.entityId)
    }

    private func removePowerUp(component: SpeedBoostComponent) {
        guard let speedBoost = entityManager.entity(with: component.entityId) else {
            return
        }

        entityManager.remove(entity: speedBoost)
    }
}
