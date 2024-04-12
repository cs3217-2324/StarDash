import Foundation

class JumpModule: MovementModule {
    let entityManager: EntityManager
    let dispatcher: EventModifiable?

    var eventHandlers: [ObjectIdentifier: (Event) -> Event?] = [:]
    lazy var listenableEvents: [ObjectIdentifier] = Array(eventHandlers.keys)

    init(entityManager: EntityManager, dispatcher: EventModifiable?) {
        self.entityManager = entityManager
        self.dispatcher = dispatcher

        eventHandlers[ObjectIdentifier(JumpEvent.self)] = { event in
            if let jumpEvent = event as? JumpEvent {
                return self.handleJumpEvent(event: jumpEvent)
            }
            return nil
        }

        eventHandlers[ObjectIdentifier(PlayerFloorContactEvent.self)] = { event in
            if let playerFloorContactEvent = event as? PlayerFloorContactEvent {
                return self.handlePlayerFloorContactEvent(event: playerFloorContactEvent)
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

    func update(by deltaTime: TimeInterval) { }

    func handleEvent(_ event: Event) -> Event? {
        let eventType = ObjectIdentifier(type(of: event))
        guard let handler = eventHandlers[eventType] else {
            return event
        }

        return handler(event)
    }

    private func createJumpComponent(for entityId: EntityId) {
        entityManager.add(component: JumpComponent(entityId: entityId))
    }

    private func removeJumpComponent(for entityId: EntityId) {
        guard let jumpComponent = entityManager.component(ofType: JumpComponent.self, of: entityId) else {
            return
        }
        entityManager.remove(component: jumpComponent)
    }

    // MARK: Event Handlers

    private func handleJumpEvent(event: JumpEvent) -> Event? {
        guard let physicsSystem = dispatcher?.system(ofType: PhysicsSystem.self),
              let soundSystem = dispatcher?.system(ofType: GameSoundSystem.self),
              entityManager.component(ofType: JumpComponent.self, of: event.entityId) == nil else {
            return nil
        }

        createJumpComponent(for: event.entityId)
        physicsSystem.applyImpulse(to: event.entityId, impulse: event.jumpImpulse)
        soundSystem.playSoundEffect(SoundEffect.playerJump)

        return nil
    }

    private func handlePlayerFloorContactEvent(event: PlayerFloorContactEvent) -> Event? {
        guard let positionSystem = dispatcher?.system(ofType: PositionSystem.self),
              let playerPosition = positionSystem.getPosition(of: event.playerId),
              playerPosition.y > event.contactPoint.y else {
            return event
        }

        removeJumpComponent(for: event.playerId)
        return event
    }

    private func handlePlayerObstacleContactEvent(event: PlayerObstacleContactEvent) -> Event? {
        guard let positionSystem = dispatcher?.system(ofType: PositionSystem.self),
              let playerPosition = positionSystem.getPosition(of: event.playerId),
              playerPosition.y > event.contactPoint.y else {
            return event
        }

        removeJumpComponent(for: event.playerId)
        return event
    }
}
