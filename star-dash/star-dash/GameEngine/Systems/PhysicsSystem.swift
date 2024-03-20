//
//  PhysicsSystem.swift
//  star-dash
//
//  Created by Ho Jun Hao on 13/3/24.
//

import Foundation

class PhysicsSystem: System {
    var isActive: Bool
    var dispatcher: EventModifiable?
    var entityManager: EntityManager

    init(_ entityManager: EntityManager, dispatcher: EventModifiable? = nil) {
        self.isActive = true
        self.dispatcher = dispatcher
        self.entityManager = entityManager
    }

    func update(by deltaTime: TimeInterval) {
        let physicsComponents = entityManager.componentMap.values.compactMap({ $0 as? PhysicsComponent })

        for physicsComponent in physicsComponents {
            physicsComponent.force = .zero
        }
    }

    func isMoving(_ entityId: EntityId) -> Bool {
        guard let physicsComponent = getPhysicsComponent(of: entityId) else {
            return false
        }

        return physicsComponent.velocity != .zero
    }

    func isJumping(_ entityId: EntityId) -> Bool {
        guard let physicsComponent = getPhysicsComponent(of: entityId) else {
            return false
        }
        return physicsComponent.velocity.dy != .zero
    }

    func applyForce(to entityId: EntityId, newForce: CGVector) {
        guard let physicsComponent = getPhysicsComponent(of: entityId) else {
            return
        }

        physicsComponent.force += newForce
    }

    func applyImpulse(to entityId: EntityId, impulse: CGVector) {
        guard let physicsComponent = getPhysicsComponent(of: entityId) else {
            return
        }

        physicsComponent.velocity += (impulse / physicsComponent.mass)
    }

    private func getPhysicsComponent(of entityId: EntityId) -> PhysicsComponent? {
        entityManager.component(ofType: PhysicsComponent.self, of: entityId)
    }
 }
