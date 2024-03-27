//
//  EventModifiable.swift
//  star-dash
//
//  Created by Jason Qiu on 14/3/24.
//

import Foundation

/// EventModifiable represents instances with entities that can be modified by events through systems.
protocol EventModifiable {
    func system<T: System>(ofType type: T.Type) -> T?
    func add(event: Event)
    func add(entity: Entity)
    func registerListener<T: Event>(for eventType: T.Type, listener: EventListener)
}
