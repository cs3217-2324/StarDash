class MoveModule: MovementModule {
    let entityManager: EntityManager
    let dispatcher: EventModifiable?

    var eventHandlers: [ObjectIdentifier: (Event, EventModifiable?) -> Void] = [:]
    var listenableEvents: [ObjectIdentifier] = Array(eventHandlers.key)

    init(entityManager: EntityManager, dispatcher: EventModifiable?) {
        self.entityManager = entityManager
        self.dispatcher = dispatcher

        eventHandlers[ObjectIdentifier(MoveEvent.self)] = { event in
            if let moveEvent = event as? MoveEvent {
                self.handleMoveEvent(event: moveEvent)
            }
        }

        eventHandlers[ObjectIdentifier(StopMovingEvent.self)] = { event in
            if let stopMovingEvent = event as? StopMovingEvent {
                self.handleStopMovingEvent(event: stopMovingEvent)
            }
        }
    }

    func update(by deltaTime: TimeInterval) { }

    func handleEvent(_ event: Event) -> Event? {
        let eventType = ObjectIdentifier(type(of: event))
        guard let handler = eventHandlers[eventType] else {
            return event
        }

        return handler(event)
    }

    // MARK: Event Handlers

    private func handleMoveEvent(event: MoveEvent) -> Event? {
        guard let physicsSystem = dispatcher?.system(ofType: PhysicsSystem.self),
              let positionSystem = dispatcher?.system(ofType: PositionSystem.self),
              let spriteSystem = dispatcher?.system(ofType: SpriteSystem.self),
              let currentVelocity = physicsSystem.velocity(of: event.entityId) else {
            return nil
        }
        let runSpeed = (event.toLeft ? -1 : 1) * PhysicsConstants.runSpeed
        var newRunSpeed = currentVelocity.dx + runSpeed
        if event.toLeft && newRunSpeed > 0 || !event.toLeft && newRunSpeed < 0 {
            newRunSpeed = runSpeed
        }
        if abs(newRunSpeed) > PhysicsConstants.maxRunSpeed {
            newRunSpeed = (event.toLeft ? -1 : 1) * PhysicsConstants.maxRunSpeed
        }
        if let buffSystem = dispatcher?.system(ofType: BuffSystem.self),
           let speedMultiplier = buffSystem.speedMultiplier(of: event.entityId) {
            newRunSpeed *= speedMultiplier
        }
        let newVelocity = CGVector(dx: newRunSpeed, dy: currentVelocity.dy)
        physicsSystem.setVelocity(to: event.entityId, velocity: newVelocity)

        positionSystem.setEntityFacingLeft(event.toLeft, entityId: event.entityId)
        spriteSystem.startAnimation(of: event.entityId, named: event.toLeft ? "runLeft" : "run")

        return nil
    }

    private func handleStopMovingEvent(event: StopMovingEvent) -> Event? {
        guard let physicsSystem = dispatcher?.system(ofType: PhysicsSystem.self),
              let positionSystem = dispatcher?.system(ofType: PositionSystem.self),
              let spriteSystem = dispatcher?.system(ofType: SpriteSystem.self) else {
            return nil
        }

        positionSystem.setEntityFacingLeft(false, entityId: event.entityId)
        physicsSystem.setVelocity(to: event.entityId,
                                  velocity: .zero)
        spriteSystem.endAnimation(of: event.entityId)

        return nil
    }
}
