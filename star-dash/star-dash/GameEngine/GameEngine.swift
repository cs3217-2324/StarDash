//
//  GameEngine.swift
//  star-dash
//
//  Created by Ho Jun Hao on 14/3/24.
//

import Foundation

class GameEngine {
    private let systemManager: SystemManager
    private let entityManager: EntityManager
    private let eventManager: EventManager
    private let gameMode: GameMode

    let mapSize: CGSize

    init(mapSize: CGSize, gameMode: GameMode) {
        self.systemManager = SystemManager()
        self.entityManager = EntityManager()
        self.eventManager = EventManager()
        self.gameMode = gameMode
        self.mapSize = mapSize

        setupSystems()
        setupGameMode()
    }

    func setupLevel(level: LevelPersistable, entities: [EntityPersistable], sceneSize: CGSize) {
        EntityFactory.createAndAddFloor(to: self,
                                        position: CGPoint(x: sceneSize.width / 2, y: 100),
                                        size: CGSize(width: sceneSize.width, height: 1))
        EntityFactory.createAndAddWall(to: self,
                                       position: CGPoint(x: 0, y: sceneSize.height / 2),
                                       size: CGSize(width: 1, height: sceneSize.height))
        EntityFactory.createAndAddWall(to: self,
                                       position: CGPoint(x: sceneSize.width, y: sceneSize.height / 2),
                                       size: CGSize(width: 1, height: sceneSize.height))
        entities.forEach({ $0.addTo(self) })
    }

    // TODO: Set up players with characters that are selected
    func setupPlayers(numberOfPlayers: Int) {
        for playerIndex in 0..<numberOfPlayers {
               // Calculate position for each player
               let position = CGPoint(x: 200, y: 200)

               // Create and add player
               EntityFactory.createAndAddPlayer(to: self,
                                                playerIndex: playerIndex,
                                                position: position)
        }

    }

    func gameInfo(forPlayer playerIndex: Int) -> GameInfo? {
        guard let scoreSystem = systemManager.system(ofType: ScoreSystem.self),
              let playerEntityId = entityManager.playerEntityId(with: playerIndex),
              let healthSystem = systemManager.system(ofType: HealthSystem.self),
              let score = scoreSystem.score(of: playerEntityId),
              let health = healthSystem.health(of: playerEntityId) else {
            return nil
        }

        return GameInfo(
            playerScore: score,
            playerHealth: health,
            playersInfo: playersInfo(),
            mapSize: mapSize
        )
    }

    func playersInfo() -> [PlayerInfo] {
        guard let positionSystem = systemManager.system(ofType: PositionSystem.self),
              let spriteSystem = systemManager.system(ofType: SpriteSystem.self) else {
            return []
        }
        let playerEntities = entityManager.playerEntities()
        var playersInfo = [PlayerInfo]()
        for playerEntity in playerEntities {
            if let position = positionSystem.getPosition(of: playerEntity.id),
               let spriteImage = spriteSystem.getImage(of: playerEntity.id) {
                playersInfo.append(PlayerInfo(position: position, spriteImage: spriteImage))
            }
        }
        return playersInfo

    }

    func update(by deltaTime: TimeInterval) {
        systemManager.update(by: deltaTime)
        eventManager.executeAll(on: self)
        checkHasGameEnded()
    }

    func handleCollision(_ entityOneId: EntityId, _ entityTwoId: EntityId, at contactPoint: CGPoint) {
        guard let entityOne = entity(of: entityOneId) as? Collidable,
              let entityTwo = entity(of: entityTwoId) as? Collidable,
              let event = entityOne.collides(with: entityTwo, at: contactPoint) else {
            return
        }

        eventManager.add(event: event)
    }

    func handlePlayerJump(playerIndex: Int) {
        guard let playerEntityId = entityManager.playerEntityId(with: playerIndex) else {
            return
        }

        eventManager.add(event: JumpEvent(on: playerEntityId, by: PhysicsConstants.jumpImpulse))
    }

    func handlePlayerMove(toLeft: Bool, playerIndex: Int) {
        guard let playerEntityId = entityManager.playerEntityId(with: playerIndex) else {
            return
        }

        eventManager.add(event: MoveEvent(on: playerEntityId, toLeft: toLeft))
    }

    func handlePlayerStoppedMoving(playerIndex: Int) {
        guard let playerEntityId = entityManager.playerEntityId(with: playerIndex) else {
            return
        }

        eventManager.add(event: StopMovingEvent(on: playerEntityId))
    }

    func handlePlayerHook(playerIndex: Int) {
        guard let playerEntityId = entityManager.playerEntityId(with: playerIndex),
              let positionComponent = entityManager.component(ofType: PositionComponent.self, of: playerEntityId) else {
            return
        }

        eventManager.add(event: UseGrappleHookEvent(from: playerEntityId, isLeft: positionComponent.isFacingLeft))
    }

    private func setupSystems() {
        // Basic Systems
        systemManager.add(PositionSystem(entityManager, dispatcher: self))
        systemManager.add(PhysicsSystem(entityManager, dispatcher: self))
        systemManager.add(ScoreSystem(entityManager, dispatcher: self))
        systemManager.add(HealthSystem(entityManager, dispatcher: self))
        systemManager.add(SpriteSystem(entityManager, dispatcher: self))

        // Complex Systems
        systemManager.add(CollisionSystem(entityManager, dispatcher: self))
        systemManager.add(InventorySystem(entityManager, dispatcher: self))
        systemManager.add(AttackSystem(entityManager, dispatcher: self))
        systemManager.add(PlayerSystem(entityManager, dispatcher: self))
        systemManager.add(MonsterSystem(entityManager, dispatcher: self))
        systemManager.add(MovementSystem(entityManager, dispatcher: self))
        systemManager.add(GrappleHookSystem(entityManager, dispatcher: self))
        systemManager.add(BuffSystem(entityManager, dispatcher: self))
        systemManager.add(PlayerDeathSystem(entityManager, dispatcher: self))

        // Power-Up Systems
        systemManager.add(PowerUpSystem(entityManager, dispatcher: self))
        systemManager.add(SpeedBoostPowerUpSystem(entityManager, dispatcher: self))
        systemManager.add(HomingMissileSystem(entityManager, dispatcher: self))
    }

    private func setupGameMode() {
        self.gameMode.setTarget(self)
    }

    private func checkHasGameEnded() {
        if gameMode.hasGameEnded() {
            // TODO: Handle game ending
        }
    }
}

extension GameEngine: EventModifiable, GameModeModifiable {
    func system<T: System>(ofType type: T.Type) -> T? {
        systemManager.system(ofType: type)
    }

    func add(event: Event) {
        eventManager.add(event: event)
    }

    func registerListener(_ listener: EventListener) {
        eventManager.registerListener(listener)
    }
}

extension GameEngine: EntitySyncInterface {
    var entities: [Entity] {
        entityManager.entities
    }

    func component<T: Component>(ofType type: T.Type, of entityId: EntityId) -> T? {
        entityManager.component(ofType: type, of: entityId)
    }

    func entity(of entityId: EntityId) -> Entity? {
        entityManager.entity(with: entityId)
    }
}

extension GameEngine: EntityManagerInterface {
    var playerIdEntityMap: [EntityId: Int] {
        var map: [EntityId: Int] = [:]
        let playerComponents = entityManager.components(ofType: PlayerComponent.self)
        playerComponents.forEach { map[$0.entityId] = $0.playerIndex }
        return map
    }

    func add(entity: Entity) {
        entityManager.add(entity: entity)
    }

    func add(component: Component) {
        entityManager.add(component: component)
    }
}
