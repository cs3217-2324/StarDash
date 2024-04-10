import Foundation

class MovementSystem: System {
    var isActive: Bool
    var dispatcher: EventModifiable?
    var entityManager: EntityManager
    var eventHandlers: [ObjectIdentifier: (Event) -> Void] = [:]
    var modules: [MovementModule] = []

    init(_ entityManager: EntityManager, dispatcher: EventModifiable? = nil) {
        self.isActive = true
        self.entityManager = entityManager
        self.dispatcher = dispatcher

        registerModules()
        registerEvents()
    }

    private func registerModules() {
        // Highest Priority
        registerModule(GrappleHookModule(entityManager: entityManager, dispatcher: dispatcher))
        registerModule(JumpModule(entityManager: entityManager, dispatcher: dispatcher))
        registerModule(MoveModule(entityManager: entityManager, dispatcher: dispatcher))
        // Lowest Priority
    }

    /// Register a `MovementModule`` in the system.
    /// Registered modules have lower priority than previously registered modules. 
    private func registerModule(_ module: MovementModule) {
        modules.append(module)
    }

    private func registerEvents() {
        dispatcher?.registerListener(self)

        for module in modules {
            for objectIdentifier in module.listenableEvents {
                eventHandlers[objectIdentifier] = { event in
                    self.handleEvent(event)
                }
            }
        }
    }

    /// Propogate update to all modules.
    func update(by deltaTime: TimeInterval) {
        for module in modules {
            module.update(by: deltaTime)
        }
    }

    /// Send events to the chain of modules.
    /// Higher priority modules receive the events earlier and controls if
    /// the event is passed down to the lower priority ones.
    /// Modules can also modify the event that is passed down.
    private func handleEvent(_ event: Event) {
        guard canMakeMovement(for: event.playerIdForEvent) else {
            return
        }

        var newEvent = event
        for module in modules {
            guard let nextEvent = module.handleEvent(newEvent) else {
               return
            }
            newEvent = nextEvent
        }
    }

    private func canMakeMovement(for playerId: EntityId?) -> Bool {
        guard let playerId = playerId,
              let playerSystem = dispatcher?.system(ofType: PlayerSystem.self),
              let isDead = playerSystem.isDead(entityId: playerId) else {
            return true
        }

        return !isDead
    }
}
