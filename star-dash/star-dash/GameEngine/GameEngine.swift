//
//  GameEngine.swift
//  star-dash
//
//  Created by Ho Jun Hao on 14/3/24.
//

import Foundation
import SpriteKit // To remove after replacing with appropriate node class mapping

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

    // TODO: after events are ready
    func handleCollision(_ entityOne: EntityId, _ entityTwo: EntityId) {}

    func handleSeparation(_ entityOne: EntityId, _ entityTwo: EntityId) {}
    // TODO: Replace SKNode with the appropriate 1 - 1 mapping when created
    func syncNodesWithEntities(_ nodes: [SKNode]) {}

    func syncEntitiesWithNodes(_ nodes: [SKNode]) {}

    private func setUpSystems() {
        systemManager.add(PositionSystem(entityManager, dispatcher: self))
        systemManager.add(PhysicsSystem(entityManager, dispatcher: self))
    }
}

extension GameEngine: EventModifiable {
    // TODO: functions of event modifiable
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
