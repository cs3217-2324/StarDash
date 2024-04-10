import Foundation

class FlyingModule  : MovementModule {
    let entityManager: EntityManager
    let dispatcher: EventModifiable?

    var eventHandlers: [ObjectIdentifier: (Event) -> Event?] = [:]
    lazy var listenableEvents: [ObjectIdentifier] = Array(eventHandlers.keys)

    init(entityManager: EntityManager, dispatcher: EventModifiable?) {
        self.entityManager = entityManager
        self.dispatcher = dispatcher

        eventHandlers[ObjectIdentifier(StartFlyingEvent.self)] = { event in
            if let flyEvent = event as? StartFlyingEvent {
                return self.handleFlyEvent(event: flyEvent)
            }
            return nil
        }

        eventHandlers[ObjectIdentifier(JumpEvent.self)] = { event in
            if let jumpEvent = event as? JumpEvent {
                return self.handleJumpEvent(event: jumpEvent)
            }
            return nil
        }

        eventHandlers[ObjectIdentifier(PlayerObstacleContactEvent.self)] = { event in
            if let playerObstacleContactEvent = event as? PlayerObstacleContactEvent {
                return self.handlePlayerObstacleContactEvent(event: playerObstacleContactEvent)
            }
            return nil
        }
    }

    func update(by deltaTime: TimeInterval) { 
        for flyingComponent in entityManager.components(ofType: FlyComponent.self) {
            updateFlyingEntity(of: flyComponent.entityId)

            flyComponent.duration = max(0, flyComponent.duration - deltaTime)
            if flyingComponent.duration <= 0 {
                cancelFlying(for: flyComponent.entityId)
            }
        }
    }

    func handleEvent(_ event: Event) -> Event? {
        let eventType = ObjectIdentifier(type(of: event))
        guard let handler = eventHandlers[eventType] else {
            return event
        }

        return handler(event)
    }

    private func createFlyComponent(for entityId: EntityId) {
        entityManager.add(component: FlyComponent(entityId: entityId))
    }

    private func removeFlyComponent(for entityId: EntityId) {
        guard let flyComponent = entityManager.component(ofType: FlyComponent.self, of: entityId) else {
            return
        }
        entityManager.remove(component: flyComponent)
    }

    private func updateFlyingEntity(for entityId: EntityId) {
        guard let physicsSystem = dispatcher?.system(ofType: PhysicsSystem.self) else {
            return
        }
        physicsSystem.applyImpulse(to: entityId, impulse: CGVector(dx: 0, dy: -50))
    }

    private func startFlying(for entityId: EntityId) {
        createFlyComponent(for: event.entityId)
        physicsSystem.setAffectedByGravity(of: event.entityId, affectedByGravity: false)
        physicsSystem.applyImpulse(to: event.entityId, impulse: event.jumpImpulse)
    }

    private func cancelFlying(for entityId: EntityId) {
        removeFlyComponent(for: entityid)
        physicsSystem.setAffectedByGravity(of: event.entityId, affectedByGravity: false)
    }

    // MARK: Event Handlers

    private func handleFlyEvent(event: StartFlyingEvent) -> Event? {
        guard let physicsSystem = dispatcher?.system(ofType: PhysicsSystem.self),
                  entityManager.component(ofType: FlyComponent.self, of: event.entityId) == nil else {
            return nil
        }

        startFlying(for: event.entityId)
        return nil
    }

    private func handleJumpEvent(event: JumpEvent) -> Event? {
        guard let physicsSystem = dispatcher?.system(ofType: PhysicsSystem.self) else {
            return
        }

        physicsSystem.applyImpulse(to: entityId, impulse: CGVector(dx: 0, dy: 200))
    }

    private func handlePlayerObstacleContactEvent(event: PlayerObstacleContactEvent) -> Event? {
        cancelFlying(for: event.playerId)
        return event
    }
}
