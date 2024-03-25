//
//  MonsterSystem.swift
//  star-dash
//
//  Created by Ho Jun Hao on 26/3/24.
//

import Foundation

class MonsterSystem: System {
    var isActive: Bool
    var dispatcher: EventModifiable?
    var entityManager: EntityManager
    var eventHandlers: [ObjectIdentifier: (Event) -> Void] = [:]

    init(_ entityManager: EntityManager, dispatcher: EventModifiable? = nil) {
        self.isActive = true
        self.entityManager = entityManager
        self.dispatcher = dispatcher
        setUpEventHandlers()
    }

    func setUpEventHandlers() {
        eventHandlers[ObjectIdentifier(MonsterDeathEvent.self)] = { event in
            if let monsterDeathEvent = event as? MonsterDeathEvent {
                self.handleMonsterDeathEvent(event: monsterDeathEvent)
            }
        }
    }

    private func handleMonsterDeathEvent(event: MonsterDeathEvent) {
        dispatcher?.add(event: RemoveEvent(on: event.entityId))
    }
}
