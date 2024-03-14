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
    
    init() {
        events = EventQueue()
    }
    
    func add(event: Event) {
        events.append(event)
    }
    
    func executeAll(on target: EventModifiable) {
        while let event = events.popFirst() {
            event.execute(on: target)
        }
    }
}
