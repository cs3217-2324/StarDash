import Foundation

class DeathSystem: System {
    var isActive: Bool
    var dispatcher: EventModifiable?
    var entityManager: EntityManager
    var eventHandlers: [ObjectIdentifier: (Event) -> Void] = [:]

    static let DEATH_TIMER: Double = 2 // 2 seconds

    init(_ entityManager: EntityManager, dispatcher: EventModifiable? = nil) {
        self.isActive = true
        self.entityManager = entityManager
        self.dispatcher = dispatcher
        setup()
    }

    func setup() {
        dispatcher?.registerListener(self)

        eventHandlers[ObjectIdentifier(DeathEvent.self)] = { event in
            if let deathEvent = event as? DeathEvent {
                self.handleDeathEvent(event: deathEvent)
            }
        }
        eventHandlers[ObjectIdentifier(PlayerDeathEvent.self)] = { event in
            if let playerDeathEvent = event as? PlayerDeathEvent {
                self.handlePlayerDeathEvent(event: playerDeathEvent)
            }
        }
        eventHandlers[ObjectIdentifier(MonsterDeathEvent.self)] = { event in
            if let monsterDeathEvent = event as? MonsterDeathEvent {
                self.handleMonsterDeathEvent(event: monsterDeathEvent)
            }
        }
    }

    func update(by deltaTime: TimeInterval) {
        guard let playerSystem = dispatcher?.system(ofType: PlayerSystem.self) else {
            return
        }

        let deathTimerComponents = entityManager.components(ofType: DeathTimerComponent.self)
        for deathTimerComponent in deathTimerComponents where deathTimerComponent.deathTimer > 0 {
            deathTimerComponent.deathTimer = max(0, deathTimerComponent.deathTimer - deltaTime)

            if deathTimerComponent.deathTimer <= 0 {
                if playerSystem.isPlayer(entityId: deathTimerComponent.entityId) {
                    respawnPlayer(deathTimerComponent.entityId)
                } else {
                    removeMonster(deathTimerComponent.entityId)
                }
            }
        }
    }

    func isDead(entityId: EntityId) -> Bool? {
        guard let deathTimerComponenet = getDeathTimerComponent(of: entityId) else {
            return nil
        }

        return deathTimerComponenet.deathTimer > 0
    }

    private func handleDeathEvent(event: DeathEvent) {
        guard let playerSystem = dispatcher?.system(ofType: PlayerSystem.self) else {
            return
        }

        if playerSystem.isPlayer(entityId: event.entityId) {
            dispatcher?.add(event: PlayerDeathEvent(on: event.entityId))
        } else {
            dispatcher?.add(event: MonsterDeathEvent(on: event.entityId))
        }
    }

    private func handlePlayerDeathEvent(event: PlayerDeathEvent) {
        guard let physicsSystem = dispatcher?.system(ofType: PhysicsSystem.self),
              let spriteSystem = dispatcher?.system(ofType: SpriteSystem.self),
              let isDead = isDead(entityId: event.playerId),
              !isDead else {
            return
        }

        physicsSystem.setVelocity(to: event.playerId, velocity: .zero)
        physicsSystem.setPinned(of: event.playerId, to: true)
        spriteSystem.startAnimation(of: event.playerId,
                                    named: "death",
                                    repetitive: false,
                                    duration: DeathSystem.DEATH_TIMER)

        setDeathTimer(to: event.playerId, timer: DeathSystem.DEATH_TIMER)
    }

    private func handleMonsterDeathEvent(event: MonsterDeathEvent) {
        guard let physicsSystem = dispatcher?.system(ofType: PhysicsSystem.self),
              let spriteSystem = dispatcher?.system(ofType: SpriteSystem.self),
              let isDead = isDead(entityId: event.monsterId),
              !isDead else {
            return
        }

        physicsSystem.setVelocity(to: event.monsterId, velocity: .zero)
        physicsSystem.setPinned(of: event.monsterId, to: true)
        spriteSystem.startAnimation(of: event.monsterId,
                                    named: "death",
                                    repetitive: false,
                                    duration: DeathSystem.DEATH_TIMER)

        setDeathTimer(to: event.monsterId, timer: DeathSystem.DEATH_TIMER)
    }

    private func respawnPlayer(_ playerId: EntityId) {
        guard let spriteSystem = dispatcher?.system(ofType: SpriteSystem.self),
              let physicsSystem = dispatcher?.system(ofType: PhysicsSystem.self),
              let healthSystem = dispatcher?.system(ofType: HealthSystem.self) else {
            return
        }

        physicsSystem.setPinned(of: playerId, to: false)
        healthSystem.setHealth(to: playerId, health: GameConstants.InitialHealth.player)
        spriteSystem.endAnimation(of: playerId)
    }

    private func removeMonster(_ monsterId: EntityId) {
        dispatcher?.add(event: RemoveEvent(on: monsterId))
    }

    private func setDeathTimer(to entityId: EntityId, timer: Double) {
        guard let deathTimerComponent = getDeathTimerComponent(of: entityId) else {
            return
        }

        deathTimerComponent.deathTimer = timer
    }

    private func getDeathTimerComponent(of entityId: EntityId) -> DeathTimerComponent? {
        entityManager.component(ofType: DeathTimerComponent.self, of: entityId)
    }
}
