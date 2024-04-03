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
        dispatcher?.registerListener(for: PlayerDeathEvent.self, listener: self)

        eventHandlers[ObjectIdentifier(PlayerDeathEvent.self)] = { event in
            if let playerDeathEvent = event as? PlayerDeathEvent {
                self.handlePlayerDeathEvent(event: playerDeathEvent)
            }
        }
    }

    func update(by deltaTime: TimeInterval) {
        let playerComponents = entityManager.components(ofType: PlayerComponent.self)

        for playerComponent in playerComponents where playerComponent.deathTimer > 0 {
            playerComponent.deathTimer = max(0, playerComponent.deathTimer - Float(deltaTime))

            if playerComponent.deathTimer == 0 {
                respawnPlayer(playerId)
            }
        }
    }   

    private func handlePlayerDeathEvent(event: PlayerDeathEvent) {
        guard let physicsSystem = dispatcher?.system(ofType: PhysicsSystem.self),
              let spriteSystem = dispatcher?.system(ofType: SpriteSystem.self),
              let playerSystem = dispatcher?.system(ofType: PlayerSystem.self) else {
            return
        }

        physicsSystem.setVelocity(to: event.playerId, velocity: .zero)
        playerSystem.setCanJump(to: event.playerId, canJump: false)
        playerSystem.setCanMove(to: event.playerId, canMove: false)
        // spriteSystem.startAnimation(of: event.entityId, named: "run")

        playerSystem.setDeathTimer(to: event.playerId, timer: 2)
    }
    
    private func respawnPlayer(_ playerId: EntityId) {
        playerSystem.setCanJump(to: playerId, canJump: true)
        playerSystem.setCanMove(to: playerId, canMove: true)
    }
}
