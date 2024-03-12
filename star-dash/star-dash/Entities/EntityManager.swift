//
//  EntityManager.swift
//  star-dash
//
//  Created by Lau Rui han on 12/3/24.
//

import Foundation
typealias ComponentSet = Set<ComponentId>
class EntityManager {
    var componentMap: [ComponentId: Component]
    var entityMap: [EntityId: Entity]
    var entityComponentMap: [EntityId: ComponentSet]
    init(componentMap: [ComponentId : Component], entityMap: [EntityId : Entity], entityComponentMap: [EntityId: ComponentSet]) {
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
