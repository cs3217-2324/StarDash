//
//  EventModifiable.swift
//  star-dash
//
//  Created by Jason Qiu on 14/3/24.
//

import Foundation

/// EventModifiable represents instances with entities that can be modified by events through systems.
protocol EventModifiable {
    func entity(with entityId: EntityId) -> Entity?
    func system<T: System>(ofType type: T.Type) -> T?
    func add(entity: Entity)
    func add(event: Event)
    func remove(entity: Entity)
    func remove(entity: EntityId)
}
