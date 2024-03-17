//
//  HealthSystem.swift
//  star-dash
//
//  Created by Jason Qiu on 17/3/24.
//

import Foundation

class HealthSystem: System {
    var isActive: Bool
    var dispatcher: EventModifiable?
    var entityManager: EntityManager

    init(_ entityManager: EntityManager, dispatcher: EventModifiable? = nil) {
        self.isActive = true
        self.entityManager = entityManager
        self.dispatcher = dispatcher
    }
    
    func hasHealth(for entityId: EntityId) -> Bool {
        guard let healthComponent = getHealthComponent(of: entityId) else {
            return false
        }

        return healthComponent.health > 0
    }

    func increaseHealth(of entityId: EntityId, by increment: Int) {
        guard let healthComponent = getHealthComponent(of: entityId) else {
            return
        }

        healthComponent.health += increment
    }
    
    func decreaseHealth(of entityId: EntityId, by decrement: Int) {
        guard let healthComponent = getHealthComponent(of: entityId) else {
            return
        }

        healthComponent.health -= decrement
    }

    private func getHealthComponent(of entityId: EntityId) -> HealthComponent? {
        entityManager.component(ofType: HealthComponent.self, of: entityId)
    }
}
