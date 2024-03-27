//
//  EntityManager.swift
//  star-dash
//
//  Created by Lau Rui han on 12/3/24.
//

import Foundation

typealias ComponentSet = Set<ComponentId>
typealias ComponentMap = [ComponentId: Component]
typealias EntityMap = [EntityId: Entity]
typealias EntityComponentMap = [EntityId: ComponentSet]

class EntityManager {
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
        self.entityComponentMap[component.entityId]?.insert(component.id)
    }

    func add(entity: Entity) {
        guard self.entityMap[entity.id] == nil else {
            return
        }
        self.entityMap[entity.id] = entity
        self.entityComponentMap[entity.id] = Set()
        entity.addComponents(to: self)
    }

    func remove(entity: Entity) {
        entityMap[entity.id] = nil

        guard let componentIds = entityComponentMap[entity.id] else {
            return
        }

        for componentId in componentIds {
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

    func entity(with entityId: EntityId) -> Entity? {
        entityMap[entityId]
    }

    func playerEntityId() -> EntityId? {
        // TODO: Add parameter to specify the player index 
        for entityId in entityMap.keys where component(ofType: PlayerComponent.self, of: entityId) != nil {
            return entityId
        }

        return nil
    }

    func component<T: Component>(ofType type: T.Type, of entityId: EntityId) -> T? {
        guard let components = entityComponentMap[entityId] else {
            return nil
        }

        guard let componentId = components.first(where: { componentMap[$0] is T }) else {
            return nil
        }

        return componentMap[componentId] as? T
    }

    func components<T: Component>(ofType type: T.Type) -> [T] {
        componentMap.values.compactMap({ $0 as? T })
    }
}
