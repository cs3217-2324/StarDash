//
//  EntityManager.swift
//  star-dash
//
//  Created by Lau Rui han on 12/3/24.
//

import Foundation

typealias ComponentMap = [ComponentId: Component]
typealias EntityMap = [EntityId: Entity]
typealias ComponentTypeIdentifier = ObjectIdentifier
typealias EntityComponentMap = [EntityId: [ComponentTypeIdentifier: ComponentId]]

class EntityManager: EntityManagerInterface {
    private var componentMap: ComponentMap
    private var entityMap: EntityMap
    private var entityComponentMap: EntityComponentMap

    init(componentMap: ComponentMap, entityMap: EntityMap, entityComponentMap: EntityComponentMap) {
        self.componentMap = componentMap
        self.entityMap = entityMap
        self.entityComponentMap = entityComponentMap
    }

    convenience init() {
        self.init(componentMap: .init(), entityMap: .init(), entityComponentMap: .init())
    }

    var entities: [Entity] {
        Array(entityMap.values)
    }

    func add(component: Component) {
        guard self.componentMap[component.id] == nil else {
            return
        }
        self.componentMap[component.id] = component

        let componentTypeIdentifier = ObjectIdentifier(type(of: component))
        self.entityComponentMap[component.entityId]?[componentTypeIdentifier] = component.id
    }

    func add(entity: Entity) {
        guard self.entityMap[entity.id] == nil else {
            return
        }
        self.entityMap[entity.id] = entity
        self.entityComponentMap[entity.id] = [:]
    }

    func remove(entity: Entity) {
        entityMap[entity.id] = nil

        guard let componentTypeIdMap = entityComponentMap[entity.id] else {
            return
        }

        for componentId in componentTypeIdMap.values {
            componentMap[componentId] = nil
        }

        entityComponentMap[entity.id] = nil
    }

    func remove(entityId: EntityId) {
        guard let entity = entity(with: entityId) else {
            return
        }

        remove(entity: entity)
    }

    func remove(component: Component) {
        componentMap[component.id] = nil
        entityComponentMap[component.entityId]?[ObjectIdentifier(type(of: component))] = nil
    }

    func entity(with entityId: EntityId) -> Entity? {
        entityMap[entityId]
    }

    func entities<T: Entity>(ofType type: T.Type) -> [T] {
        entityMap.values.compactMap({ $0 as? T })
    }

    func playerEntityId(with playerIndex: Int) -> EntityId? {
        for entityId in entityMap.keys {
            if let playerComponent = component(ofType: PlayerComponent.self, of: entityId),
               playerComponent.playerIndex == playerIndex {
                return entityId
            }
        }
        return nil
    }

    func playerEntities() -> [Entity] {
        var playerEntities = [Entity]()
        for (_, entity) in entityMap where entity is Player {
            playerEntities.append(entity)
        }
        return playerEntities
    }

    func finishLineEntity() -> Entity? {
        for entity in entityMap.values where entity is FinishLine {
            return entity
        }
        return nil
    }

    func component<T: Component>(ofType type: T.Type, of entityId: EntityId) -> T? {
        guard let componentTypeIdMap = entityComponentMap[entityId] else {
            return nil
        }

        let componentTypeIdentifier = ObjectIdentifier(type)
        guard let componentId = componentTypeIdMap[componentTypeIdentifier] else {
            return nil
        }

        return componentMap[componentId] as? T
    }

    func components<T: Component>(ofType type: T.Type) -> [T] {
        componentMap.values.compactMap({ $0 as? T })
    }
}
