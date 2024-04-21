import Foundation

class MoveModule: MovementModule {
    let entityManager: EntityManager
    let dispatcher: EventModifiable?

    var eventHandlers: [ObjectIdentifier: (Event) -> Event?] = [:]
    lazy var listenableEvents: [ObjectIdentifier] = Array(eventHandlers.keys)

    init(entityManager: EntityManager, dispatcher: EventModifiable?) {
        self.entityManager = entityManager
        self.dispatcher = dispatcher

        eventHandlers[ObjectIdentifier(MoveEvent.self)] = { event in
            if let moveEvent = event as? MoveEvent {
                return self.handleMoveEvent(event: moveEvent)
            }
            return nil
        }

        eventHandlers[ObjectIdentifier(StopMovingEvent.self)] = { event in
            if let stopMovingEvent = event as? StopMovingEvent {
                return self.handleStopMovingEvent(event: stopMovingEvent)
            }
            return nil
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
              let currentVelocity = physicsSystem.velocity(of: event.entityId),
              let maxRunSpeed = physicsSystem.maxRunSpeed(of: event.entityId) else {
            return nil
        }

        var newRunSpeed: CGFloat = event.toLeft ? -1 : 1
        if currentVelocity.dx > 0 && event.toLeft || !event.toLeft && currentVelocity.dx < 0 { // changed direction
            newRunSpeed *= PhysicsConstants.runSpeed
        } else {
            newRunSpeed *= min(maxRunSpeed, abs(currentVelocity.dx) + PhysicsConstants.runSpeed)
        }

        if let buffSystem = dispatcher?.system(ofType: BuffSystem.self),
           let speedMultiplier = buffSystem.speedMultiplier(of: event.entityId) {
            newRunSpeed *= speedMultiplier
        }
        let newVelocity = CGVector(dx: newRunSpeed, dy: currentVelocity.dy)
        physicsSystem.setVelocity(to: event.entityId, velocity: newVelocity)

        positionSystem.setEntityFacingLeft(event.toLeft, entityId: event.entityId)
        spriteSystem.startAnimation(of: event.entityId, named: event.toLeft ? "runLeft" : "run")
        spriteSystem.setImageDirection(of: event.entityId, to: event.toLeft ? "faceLeft" : "faceRight")

        return nil
    }

    func cancelMovement(for entityId: EntityId) {
        cancelMovement(of: entityId, endAnimation: false)
    }

    private func cancelMovement(of entityId: EntityId, endAnimation: Bool = true) {
        guard let physicsSystem = dispatcher?.system(ofType: PhysicsSystem.self),
              let spriteSystem = dispatcher?.system(ofType: SpriteSystem.self) else {
            return
        }

        if endAnimation {
            spriteSystem.endAnimation(of: entityId)
        }
        physicsSystem.setVelocity(to: entityId, velocity: .zero)
    }

    private func handleStopMovingEvent(event: StopMovingEvent, endAnimation: Bool = true) -> Event? {
        cancelMovement(of: event.entityId)
        return nil
    }
}
