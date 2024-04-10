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
    var eventHandlers: [ObjectIdentifier: (Event) -> Void] = [:]

    init(_ entityManager: EntityManager, dispatcher: EventModifiable? = nil) {
        self.isActive = true
        self.dispatcher = dispatcher
        self.entityManager = entityManager
        setup()
    }

    func update(by deltaTime: TimeInterval) {
        let physicsComponents = entityManager.components(ofType: PhysicsComponent.self)

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

    func applyImpulse(to entityId: EntityId, impulse: CGVector) {
        guard let physicsComponent = getPhysicsComponent(of: entityId) else {
            return
        }

        physicsComponent.velocity += (impulse / physicsComponent.mass)
    }

    func setVelocity(to entityId: EntityId, velocity: CGVector) {
        guard let physicsComponent = getPhysicsComponent(of: entityId) else {
            return
        }

        physicsComponent.velocity = velocity
    }

    func velocity(of entityId: EntityId) -> CGVector? {
        guard let physicsComponent = getPhysicsComponent(of: entityId) else {
            return nil
        }

        return physicsComponent.velocity
    }

    func getSize(of entityId: EntityId) -> CGSize? {
        guard let physicsComponent = getPhysicsComponent(of: entityId) else {
            return nil
        }

        guard physicsComponent.shape == .rectangle else {
            return nil
        }

        return physicsComponent.size
    }

    func setSize(of entityId: EntityId, to size: CGSize) {
        guard let physicsComponent = getPhysicsComponent(of: entityId) else {
            return
        }

        guard physicsComponent.shape == .rectangle else {
            return
        }

        physicsComponent.size = size
    }

    func setPinned(of entityId: EntityId, to pinned: Bool) {
        guard let physicsComponent = getPhysicsComponent(of: entityId) else {
            return
        }

        physicsComponent.pinned = pinned
    }

    func setup() {}

    private func getPhysicsComponent(of entityId: EntityId) -> PhysicsComponent? {
        entityManager.component(ofType: PhysicsComponent.self, of: entityId)
    }
 }
