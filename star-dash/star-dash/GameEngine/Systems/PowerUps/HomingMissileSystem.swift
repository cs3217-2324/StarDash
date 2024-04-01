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

    func setup() {
        dispatcher?.registerListener(for: MissileHitPlayerEvent.self, listener: self)

        eventHandlers[ObjectIdentifier(MissileHitPlayerEvent.self)] = { event in
            if let missileHitPlayerEvent = event as? MissileHitPlayerEvent {
                self.handleMissleHitPlayerEvent(event: missileHitPlayerEvent)
            }
        }
    }

    func update(by deltaTime: TimeInterval) {
        for homingMissleComponent in entityManager.components(ofType: HomingMissleComponent.self) {
            if !homingMissleComponent.isActivated {
                fireMissle(component: homingMissleComponent)
                continue
            }

            updateMissle(component: homingMissleComponent)
        }
    }

    private func fireMissle(component: homingMissleComponent) {
        guard let physicsSystem = dispatcher?.system(ofType: PhysicsSystem),
            !component.isActivated else {
            return
        }

        component.isActivated = true
        physicsSystem.applyImpulse(to: component.entityId, impulse: component.impulse)
        
        // search for a target
        guard let positionSystem = dispatcher?.system(ofType: PositionSystem),
              let misslePosition = positionSystem.getPosition(of: component.entityId),
              let targetId = positionSystem.getEntityAhead(of: misslePosition, ofType: Player.self),
              component.targetId == nil else {
            return
        }
        
        component.targetId = targetId
    }

    private func updateMissle(component: homingMissleComponent) {
        guard let targetId = component.targetId,
              let positionSystem = dispatcher?.system(ofType: PositionSystem),
              let physicsSystem = dispatcher?.system(ofType: PhysicsSystem),
              let misslePosition = positionSystem.getPosition(of: component.entityId),
              let targetPosition = positionSystem.getPosition(of: targetId),
              let missleVelocity = physicsSystem.velocity(of: componenty.entityId) else {
            return
        }

        let dy = misslePosition.y - targetPosition.y
        let dx = misslePosition.x - targetPosition.x
        let distance = hypot(dx, dy)

        let newVelocity = CGVector(dx: dx / distance, dy: dy / distance) * missleVelocity.magnitude 
        physicsSystem.setVelocity(to: component.entityId, velocity: unitVector)
    }

    // Event Handlers

    private func handleMissleHitPlayerEvent(event: MissileHitPlayerEvent) {
        dispatcher?.add(event: PlayerDeathEvent(on: event.entityId))
        print("player hit")
    }
}
