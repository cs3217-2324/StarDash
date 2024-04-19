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
        dispatcher?.registerListener(self)

        eventHandlers[ObjectIdentifier(MissileHitPlayerEvent.self)] = { event in
            if let missileHitPlayerEvent = event as? MissileHitPlayerEvent {
                self.handleMissileHitPlayerEvent(event: missileHitPlayerEvent)
            }
        }

        eventHandlers[ObjectIdentifier(MissileBlockedEvent.self)] = { event in
            if let missileBlockedEvent = event as? MissileBlockedEvent {
                self.handleMissileBlockedEvent(event: missileBlockedEvent)
            }
        }
    }

    func update(by deltaTime: TimeInterval) {
        for homingMissileComponent in entityManager.components(ofType: HomingMissileComponent.self) {
            if !homingMissileComponent.isActivated {
                fireMissile(component: homingMissileComponent)
            }

            updateMissile(component: homingMissileComponent)
        }
    }

    private func fireMissile(component: HomingMissileComponent) {
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

    private func updateMissile(component: HomingMissileComponent) {
        if component.targetId == nil {
            aimMissileForward(component: component)
        } else {
            aimMissile(component: component)
        }
    }

    private func aimMissileForward(component: HomingMissileComponent) {
        guard let positionSystem = dispatcher?.system(ofType: PositionSystem.self) else {
            return
        }

        positionSystem.rotate(entityId: component.entityId, inDirection: CGVector(dx: 1, dy: 0))
    }

    private func aimMissile(component: HomingMissileComponent) {
        guard let targetId = component.targetId,
              let positionSystem = dispatcher?.system(ofType: PositionSystem.self),
              let physicsSystem = dispatcher?.system(ofType: PhysicsSystem.self),
              let missilePosition = positionSystem.getPosition(of: component.entityId),
              let targetPosition = positionSystem.getPosition(of: targetId),
              let missileVelocity = physicsSystem.velocity(of: component.entityId) else {
            return
        }

        let dy = targetPosition.y - missilePosition.y
        let dx = targetPosition.x - missilePosition.x
        let distance = hypot(dx, dy)

        let newVelocity = CGVector(dx: dx / distance, dy: dy / distance) * missileVelocity.magnitude
        physicsSystem.setVelocity(to: component.entityId, velocity: newVelocity)
        positionSystem.rotate(entityId: component.entityId, inDirection: newVelocity)
    }

    // Event Handlers

    private func handleMissileHitPlayerEvent(event: MissileHitPlayerEvent) {
        if let missileComponent = entityManager.component(ofType: HomingMissileComponent.self, of: event.entityId),
           let sourceId = missileComponent.sourceId,
           sourceId == event.entityId {
            return
        }

        dispatcher?.add(event: PlayerDeathEvent(on: event.entityId))
        entityManager.remove(entityId: event.missileId)
    }

    private func handleMissileBlockedEvent(event: MissileBlockedEvent) {
        entityManager.remove(entityId: event.missileId)
    }
}
