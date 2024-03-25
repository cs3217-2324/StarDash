//
//  EventListener.swift
//  star-dash
//
//  Created by Ho Jun Hao on 25/3/24.
//

protocol EventListener: AnyObject {
    var eventHandlers: [ObjectIdentifier: (Event) -> Void] { get set }

    func handleEvent(event: Event)
    func setUpEventHandlers()
}

extension EventListener {
    func handleEvent(event: Event) {
        let eventType = ObjectIdentifier(type(of: event))
        guard let handler = eventHandlers[eventType] else {
            return
        }
        handler(event)
    }
}
