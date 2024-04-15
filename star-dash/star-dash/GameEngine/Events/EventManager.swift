import Foundation
typealias EventQueue = Heap<Event>

class EventManager {
    private var events: EventQueue
    private var listeners: [EventListener]

    init() {
        self.events = EventQueue(comparator: { $0.timestamp < $1.timestamp })
        self.listeners = []
    }

    func add(event: Event) {
        events.insert(item: event)
    }

    func executeAll(on target: EventModifiable) {
        while let event = events.popTop() {

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
