import Foundation

class FlyingModule: MovementModule {
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

        eventHandlers[ObjectIdentifier(PlayerFloorContactEvent.self)] = { event in
            if let playerFloorContactEvent = event as? PlayerFloorContactEvent {
                return self.handlePlayerFloorContactEvent(event: playerFloorContactEvent)
            }
            return nil
        }

        eventHandlers[ObjectIdentifier(MoveEvent.self)] = { event in self.interceptMove(event: event) }
        eventHandlers[ObjectIdentifier(StopMovingEvent.self)] = { event in self.interceptMove(event: event) }
    }

    func update(by deltaTime: TimeInterval) {
        for flyComponent in entityManager.components(ofType: FlyComponent.self) {
            updateFlyingEntity(for: flyComponent.entityId)

            flyComponent.duration = max(0, flyComponent.duration - deltaTime)
            if flyComponent.duration <= 0 {
                cancelFlying(for: flyComponent.entityId)
            }
        }
    }

    func handleEvent(_ event: Event) -> Event? {
        let eventType = ObjectIdentifier(type(of: event))
        if let handler = eventHandlers[eventType] {
            return handler(event)
        }

        guard let playerId = event.playerIdForEvent,
              entityIsFlying(for: playerId) else {
            return event
        }

        return nil
    }

    private func createFlyComponent(for entityId: EntityId, duration: Double) {
        entityManager.add(component: FlyComponent(entityId: entityId, duration: 10))
    }

    private func removeFlyComponent(for entityId: EntityId) {
        guard let flyComponent = entityManager.component(ofType: FlyComponent.self, of: entityId) else {
            return
        }
        entityManager.remove(component: flyComponent)
    }

    private func entityIsFlying(for entityId: EntityId) -> Bool {
        entityManager.component(ofType: FlyComponent.self, of: entityId) != nil
    }

    private func updateFlyingEntity(for entityId: EntityId) {
        guard let physicsSystem = dispatcher?.system(ofType: PhysicsSystem.self) else {
            return
        }

        physicsSystem.applyImpulse(to: entityId, impulse: CGVector(dx: 0, dy: -50))
    }

    private func startFlying(for entityId: EntityId) {
        guard let physicsSystem = dispatcher?.system(ofType: PhysicsSystem.self),
              let spriteSystem = dispatcher?.system(ofType: SpriteSystem.self) else {
            return
        }
        let duration: Double = 10 // 10 seconds

        createFlyComponent(for: entityId, duration: duration)
        physicsSystem.setAffectedByGravity(of: entityId, affectedByGravity: false)
        physicsSystem.applyImpulse(to: entityId, impulse: CGVector(dx: 4_000, dy: 2_000))
        spriteSystem.startAnimation(of: entityId, named: "fly")
        spriteSystem.setSize(of: entityId, to: PhysicsConstants.Dimensions.plane)
    }

    private func cancelFlying(for entityId: EntityId) {
        guard let physicsSystem = dispatcher?.system(ofType: PhysicsSystem.self),
              let spriteSystem = dispatcher?.system(ofType: SpriteSystem.self) else {
            return
        }

        removeFlyComponent(for: entityId)
        physicsSystem.setAffectedByGravity(of: entityId, affectedByGravity: true)
        physicsSystem.setVelocity(to: entityId, velocity: .zero)
        spriteSystem.endAnimation(of: entityId)
        spriteSystem.setSize(of: entityId, to: PhysicsConstants.Dimensions.player)
    }

    // MARK: Event Handlers

    private func handleFlyEvent(event: StartFlyingEvent) -> Event? {
        guard !entityIsFlying(for: event.entityId) else {
            return nil
        }

        startFlying(for: event.entityId)
        return nil
    }

    private func handleJumpEvent(event: JumpEvent) -> Event? {
        guard entityIsFlying(for: event.entityId) else {
            return event
        }

        guard let physicsSystem = dispatcher?.system(ofType: PhysicsSystem.self) else {
            return nil
        }

        physicsSystem.applyImpulse(to: event.entityId, impulse: CGVector(dx: 0, dy: 4_000))
        return nil
    }

    private func handlePlayerObstacleContactEvent(event: PlayerObstacleContactEvent) -> Event? {
        guard entityIsFlying(for: event.playerId) else {
            return event
        }

        cancelFlying(for: event.playerId)
        return event
    }

    private func handlePlayerFloorContactEvent(event: PlayerFloorContactEvent) -> Event? {
        guard entityIsFlying(for: event.playerId) else {
            return event
        }

        cancelFlying(for: event.playerId)
        return event
    }

    private func interceptMove(event: Event) -> Event? {
        guard let playerId = event.playerIdForEvent,
              entityIsFlying(for: playerId) else {
            return event
        }

        return nil
    }
}