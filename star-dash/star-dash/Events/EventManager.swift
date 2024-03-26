//
//  EventManager.swift
//  star-dash
//
//  Created by Jason Qiu on 14/3/24.
//

import DequeModule
import Foundation

typealias EventQueue = Deque<Event>

class EventManager {
    private var events: EventQueue
    private var listeners: [ObjectIdentifier: [EventListener]]

    init() {
        self.events = EventQueue()
        self.listeners = [:]
    }

    func add(event: Event) {
        events.append(event)
    }

    func executeAll(on target: EventModifiable) {
        while let event = events.popFirst() {
            emit(event: event)
        }
    }

    func registerListener<T: Event>(for eventType: T.Type, listener: EventListener) {
        let key = ObjectIdentifier(eventType)
        if listeners[key] == nil {
            listeners[key] = []
        }
        listeners[key]?.append(listener)
    }

    func emit(event: Event) {
        let key = ObjectIdentifier(type(of: event))
        if let eventListeners = listeners[key] {
            for listener in eventListeners {
                listener.handleEvent(event: event)
            }
        }
    }
}
