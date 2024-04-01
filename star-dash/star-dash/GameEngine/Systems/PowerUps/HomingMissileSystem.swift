import Foundation

class HomingMissileSystem: System, EventListener {
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
        dispatcher?.registerListener(for: MissileHitPlayerEvent.self, listener: self)

        eventHandlers[ObjectIdentifier(MissileHitPlayerEvent.self)] = { event in
            if let missileHitPlayerEvent = event as? MissileHitPlayerEvent {
                self.handleMissleHitPlayerEvent(event: missileHitPlayerEvent)
            }
        }
    }

    func update(by deltaTime: TimeInterval) {
        for homingMissleComponent in entityManager.components(ofType: HomingMissileComponent.self) {
            if !homingMissleComponent.isActivated {
                fireMissle(component: homingMissleComponent)
                continue
            }

            updateMissle(component: homingMissleComponent)
        }
    }

    private func fireMissle(component: HomingMissileComponent) {
        guard let physicsSystem = dispatcher?.system(ofType: PhysicsSystem.self),
            !component.isActivated else {
            return
        }

        component.isActivated = true
        physicsSystem.applyImpulse(to: component.entityId, impulse: component.impulse)

        // search for a target
        guard let positionSystem = dispatcher?.system(ofType: PositionSystem.self),
              let missilePosition = positionSystem.getPosition(of: component.entityId),
              let targetId = positionSystem.getEntityAhead(of: missilePosition, ofType: Player.self),
              component.targetId == nil else {
            return
        }

        component.targetId = targetId
    }

    private func updateMissle(component: HomingMissileComponent) {
        guard let targetId = component.targetId,
              let positionSystem = dispatcher?.system(ofType: PositionSystem.self),
              let physicsSystem = dispatcher?.system(ofType: PhysicsSystem.self),
              let misslePosition = positionSystem.getPosition(of: component.entityId),
              let targetPosition = positionSystem.getPosition(of: targetId),
              let missleVelocity = physicsSystem.velocity(of: component.entityId) else {
            return
        }

        let dy = targetPosition.y - misslePosition.y
        let dx = targetPosition.x - misslePosition.x
        let distance = hypot(dx, dy)

        let newVelocity = CGVector(dx: dx / distance, dy: dy / distance) * missleVelocity.magnitude
        physicsSystem.setVelocity(to: component.entityId, velocity: newVelocity)
    }

    // Event Handlers

    private func handleMissleHitPlayerEvent(event: MissileHitPlayerEvent) {
        dispatcher?.add(event: PlayerDeathEvent(on: event.entityId))
        entityManager.remove(entityId: event.entityId)
    }
}
