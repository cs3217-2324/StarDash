import Foundation

class MovementSystem: System {
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

        eventHandlers[ObjectIdentifier(MoveEvent.self)] = { event in
            if let moveEvent = event as? MoveEvent {
                self.handleMoveEvent(event: moveEvent)
            }
        }
        eventHandlers[ObjectIdentifier(JumpEvent.self)] = { event in
            if let jumpEvent = event as? JumpEvent {
                self.handleJumpEvent(event: jumpEvent)
            }
        }
        eventHandlers[ObjectIdentifier(StopMovingEvent.self)] = { event in
            if let stopMovingEvent = event as? StopMovingEvent {
                self.handleStopMovingEvent(event: stopMovingEvent)
            }
        }
    }

    private func handleMoveEvent(event: MoveEvent) {
        guard let physicsSystem = dispatcher?.system(ofType: PhysicsSystem.self),
              let positionSystem = dispatcher?.system(ofType: PositionSystem.self),
              let spriteSystem = dispatcher?.system(ofType: SpriteSystem.self),
              let playerSystem = dispatcher?.system(ofType: PlayerSystem.self),
              let currentVelocity = physicsSystem.velocity(of: event.entityId),
              playerSystem.canMove(for: event.entityId) else {
            return
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
            newRunSpeed *= CGFloat(speedMultiplier)
        }
        let newVelocity = CGVector(dx: newRunSpeed, dy: currentVelocity.dy)
        physicsSystem.setVelocity(to: event.entityId, velocity: newVelocity)

        positionSystem.setEntityFacingLeft(event.toLeft, entityId: event.entityId)
        spriteSystem.startAnimation(of: event.entityId, named: event.toLeft ? "runLeft" : "run")
    }

    private func handleJumpEvent(event: JumpEvent) {
        guard let physicsSystem = dispatcher?.system(ofType: PhysicsSystem.self),
              let playerSystem = dispatcher?.system(ofType: PlayerSystem.self),
              playerSystem.canJump(for: event.entityId) else {
            return
        }

        playerSystem.setCanJump(to: event.entityId, canJump: false)
        physicsSystem.applyImpulse(to: event.entityId, impulse: event.jumpImpulse)
    }

    private func handleStopMovingEvent(event: StopMovingEvent) {
        guard let physicsSystem = dispatcher?.system(ofType: PhysicsSystem.self),
              let positionSystem = dispatcher?.system(ofType: PositionSystem.self),
              let spriteSystem = dispatcher?.system(ofType: SpriteSystem.self) else {
            return
        }

        positionSystem.setEntityFacingLeft(false, entityId: event.entityId)
        physicsSystem.setVelocity(to: event.entityId,
                                  velocity: .zero)
        spriteSystem.endAnimation(of: event.entityId)
    }
}
