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
    var componentMap: ComponentMap
    var entityMap: EntityMap
    var entityComponentMap: EntityComponentMap
    init(componentMap: ComponentMap, entityMap: EntityMap, entityComponentMap: EntityComponentMap) {
        self.componentMap = componentMap
        self.entityMap = entityMap
        self.entityComponentMap = entityComponentMap
    }
    
    convenience init() {
        self.init(componentMap: .init(), entityMap: .init(), entityComponentMap: .init())
    }
    
    func add(component: Component) {
        guard self.componentMap[component.id] != nil else {
            return
        }
        self.componentMap[component.id] = component
        self.entityComponentMap[component.entityId]?.insert(component.id)
    }
    
    func add(entity: Entity) {
        guard self.entityMap[entity.id] != nil else {
            return
        }
        self.entityMap[entity.id] = entity
    }
}
