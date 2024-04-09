class JumpModule: MovementModule {
    var eventHandlers: [ObjectIdentifier: (Event, EventModifiable?) -> Void] = [:]
    var listenableEvents: [ObjectIdentifier] = Array(eventHandlers.key)

    init(entityManager: EntityManager, dispatcher: EventModifiable?) {
        let entityManager: EntityManager
        let dispatcher: EventModifiable?

        self.entityManager = entityManager
        self.dispatcher = dispatcher

        eventHandlers[ObjectIdentifier(JumpEvent.self)] = { event in
            if let jumpEvent = event as? JumpEvent {
                self.handleJumpEvent(event: jumpEvent)
            }
        }

        eventHandlers[ObjectIdentifier(PlayerFloorContactEvent.self)] = { event in
            if let playerFloorContactEvent = event as? PlayerFloorContactEvent {
                self.handlePlayerFloorContactEvent(event: playerFloorContactEvent)
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

    private func createJumpComponent(for entityId: EntityId) {
        entityManager.add(component: JumpComponent(entityId: entityId))
    }

    private func removeJumpComponent(for entityId: EntityId) {
        guard let jumpComponent = entityManager.component(ofType: JumpComponent.self, of: event.entityId) {
            return
        }
        entityManager.remove(component: jumpComponent)
    }

    // MARK: Event Handlers

    private func handleJumpEvent(event: JumpEvent) -> Event? {
        guard let physicsSystem = dispatcher?.system(ofType: PhysicsSystem.self),
                  entityManager.component(ofType: JumpComponent.self, of: event.entityId) == nil else {
            return nil
        }
        
        createJumpComponent(for: event.entityId)
        physicsSystem.applyImpulse(to: event.entityId, impulse: event.jumpImpulse)

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
