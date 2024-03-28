import Foundation

class PowerUpSystem: System {
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

    func setup() {
        dispatcher?.registerListener(for: PowerUpPlayerEvent.self, listener: self)

        eventHandlers[ObjectIdentifier(PowerUpPlayerEvent.self)] = { event in
            if let powerUpPlayerEvent = event as? PowerUpPlayerEvent {
                self.handlePlayerPickedUpPowerUpEvent(event: powerUpPlayerEvent)
            }
        }
    }

    private func handlePlayerPickedUpPowerUpEvent(event: PowerUpPlayerEvent) {
        guard let powerUp = PowerUpFactory.createSpeedBoostPowerUp(triggerdBy: event.entityId) else {
            return
        }

        entityManager.add(entity: powerUp)
    }
}
