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

    init() {
        self.systemManager = SystemManager()
        self.entityManager = EntityManager()
        self.eventManager = EventManager()

        setUpSystems()
    }

    func gameInfo(forPlayer playerIndex: Int) -> GameInfo? {
        guard let scoreSystem = systemManager.system(ofType: ScoreSystem.self),
              let playerEntityId = entityManager.playerEntityId(with: playerIndex),
              let score = scoreSystem.score(of: playerEntityId) else {
            return nil
        }

        return GameInfo(
            playerScore: score,
            playersInfo: playersInfo(of: playerIndex)
        )
    }

    func playersInfo(of playerIndex: Int) -> [PlayerInfo] {
        guard let playerEntityId = entityManager.playerEntityId(with: playerIndex),
              let positionSystem = systemManager.system(ofType: PositionSystem.self) else {
            return []
        }
        var playersInfo = [PlayerInfo]()
        if let position = positionSystem.getPosition(of: playerEntityId) {
            playersInfo.append(PlayerInfo(position: position, player: .RedNose))
        }
        return playersInfo

    }

    func update(by deltaTime: TimeInterval) {
        systemManager.update(by: deltaTime)
        eventManager.executeAll(on: self)
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
        guard let playerEntityId = entityManager.playerEntityId(with: playerIndex),
              let playerComponent = entityManager.component(ofType: PlayerComponent.self, of: playerEntityId),
              playerComponent.canMove else {
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

    private func setUpSystems() {
        systemManager.add(PositionSystem(entityManager, dispatcher: self))
        systemManager.add(PhysicsSystem(entityManager, dispatcher: self))
        systemManager.add(ScoreSystem(entityManager, dispatcher: self))
        systemManager.add(HealthSystem(entityManager, dispatcher: self))
        systemManager.add(InventorySystem(entityManager, dispatcher: self))
        systemManager.add(AttackSystem(entityManager, dispatcher: self))
        systemManager.add(PlayerSystem(entityManager, dispatcher: self))
        systemManager.add(CollisionSystem(entityManager, dispatcher: self))
        systemManager.add(MonsterSystem(entityManager, dispatcher: self))
    }
}

extension GameEngine: EventModifiable {
    func system<T: System>(ofType type: T.Type) -> T? {
        systemManager.system(ofType: type)
    }

    func add(event: Event) {
        eventManager.add(event: event)
    }

    func registerListener<T: Event>(for eventType: T.Type, listener: EventListener) {
        eventManager.registerListener(for: eventType, listener: listener)
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
    func add(entity: Entity) {
        entityManager.add(entity: entity)
    }

    func add(component: Component) {
        entityManager.add(component: component)
    }
}
