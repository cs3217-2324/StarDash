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
    private var listeners: [EventListener]

    init() {
        self.events = EventQueue()
        self.listeners = []
    }

    func add(event: Event) {
        events.append(event)
    }

    func executeAll(on target: EventModifiable) {
        while let event = events.popFirst() {
            Logger.logEvent(subtitle: "Event Manager", message: "\(event) execute", level: .info)
            emit(event: event)
        }
    }

    func registerListener(_ listener: EventListener) {
        listeners.append(listener)
    }

    private func emit(event: Event) {
        listeners.forEach { $0.handleEvent(event: event) }
    }
}
