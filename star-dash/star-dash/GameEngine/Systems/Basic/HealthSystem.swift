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
    var eventHandlers: [ObjectIdentifier: (Event) -> Void] = [:]

    init(_ entityManager: EntityManager, dispatcher: EventModifiable? = nil) {
        self.isActive = true
        self.entityManager = entityManager
        self.dispatcher = dispatcher
        setup()
    }

    func health(of entityId: EntityId) -> Int? {
        guard let healthComponent = getHealthComponent(of: entityId) else {
            return false
        }

        return healthComponent.health
    }
 
    func hasHealth(for entityId: EntityId) -> Bool {
        guard let healthComponent = getHealthComponent(of: entityId) else {
            return false
        }

        return healthComponent.health > 0
    }

    func applyHealthChange(to entityId: EntityId, healthChange: Int) {
        guard let healthComponent = getHealthComponent(of: entityId) else {
            return
        }

        healthComponent.health += healthChange
    }

    func setHealth(to entityId: EntityId, health: Int) {
        guard let healthComponent = getHealthComponent(of: entityId) else {
            return
        }

        healthComponent.health = health
    }

    func setup() {}

    private func getHealthComponent(of entityId: EntityId) -> HealthComponent? {
        entityManager.component(ofType: HealthComponent.self, of: entityId)
    }
}
