//
//  GameEngine.swift
//  star-dash
//
//  Created by Ho Jun Hao on 14/3/24.
//

import Foundation

class GameEngine {
    private let systemManager: SystemManager
    let entityManager: EntityManager // TODO: Set to private
    private let eventManager: EventManager

    init() {
        self.systemManager = SystemManager()
        self.entityManager = EntityManager()
        self.eventManager = EventManager()

        setUpSystems()
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

    func handlePlayerJump() {
        guard let playerEntityId = entityManager.playerEntityId() else {
            return
        }

        eventManager.add(event: JumpEvent(on: playerEntityId, by: PhysicsConstants.jumpImpulse))
    }

    func handlePlayerMove() {

    }

    private func setUpSystems() {
        systemManager.add(PositionSystem(entityManager, dispatcher: self))
        systemManager.add(PhysicsSystem(entityManager, dispatcher: self))
    }
}

extension GameEngine: EventModifiable {
    func entity(with entityId: EntityId) -> Entity? {
        entityManager.entity(with: entityId)
    }

    func system<T: System>(ofType type: T.Type) -> T? {
        systemManager.system(ofType: type)
    }

    func component<T: Component>(ofType type: T.Type, ofEntity entityId: EntityId) -> T? {
        entityManager.component(ofType: type, of: entityId)
    }

    func add(entity: Entity) {
        entityManager.add(entity: entity)
    }

    func add(event: Event) {
        eventManager.add(event: event)
    }

    func remove(entity: Entity) {
        entityManager.remove(entity: entity)
    }
}

extension GameEngine: EntitySyncInterface {

    var entities: [Entity] {
        Array(entityManager.entityMap.values)
    }

    func component<T: Component>(ofType type: T.Type, of entityId: EntityId) -> T? {
        entityManager.component(ofType: type, of: entityId)
    }

    func entity(of entityId: EntityId) -> Entity? {
        entityManager.entityMap[entityId]
    }
}
