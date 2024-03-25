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
        setUpEventHandlers()
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

    func getSize(of entityId: EntityId) -> CGSize? {
        guard let physicsComponent = getPhysicsComponent(of: entityId) else {
            return nil
        }

        guard physicsComponent.shape == .rectangle else {
            return nil
        }

        return physicsComponent.size
    }

    func setUpEventHandlers() {
        dispatcher?.registerListener(for: MoveEvent.self, listener: self)
        dispatcher?.registerListener(for: JumpEvent.self, listener: self)
        dispatcher?.registerListener(for: StopMovingEvent.self, listener: self)

        eventHandlers[ObjectIdentifier(MoveEvent.self)] = { event in
            if let moveEvent = event as? MoveEvent {
                self.handleMoveEvent(event: moveEvent)
            }
        }
        eventHandlers[ObjectIdentifier(JumpEvent.self)] = { event in
            if let jumpEvent = event as? JumpEvent {
                self.handleJumpEvent(event: jumpEvent)
            }
        }
        eventHandlers[ObjectIdentifier(StopMovingEvent.self)] = { event in
            if let stopMovingEvent = event as? StopMovingEvent {
                self.handleStopMovingEvent(event: stopMovingEvent)
            }
        }
    }

    private func handleMoveEvent(event: MoveEvent) {
        guard let physicsComponent = getPhysicsComponent(of: event.entityId),
              let spriteComponent = entityManager.component(ofType: SpriteComponent.self, of: event.entityId),
              let textureSet = spriteComponent.textureSet else {
            return
        }

        physicsComponent.velocity = (event.toLeft ? -1 : 1) * PhysicsConstants.runVelocity
        spriteComponent.textureAtlas = textureSet.run
    }

    private func handleJumpEvent(event: JumpEvent) {
        guard let playerComponent = entityManager.component(ofType: PlayerComponent.self, of: event.entityId),
              playerComponent.canJump else {
            return
        }
        playerComponent.canJump = false
        playerComponent.canMove = false

        applyImpulse(to: event.entityId, impulse: event.jumpImpulse)
    }

    private func handleStopMovingEvent(event: StopMovingEvent) {
        guard let physicsComponent = getPhysicsComponent(of: event.entityId),
              let spriteComponent = entityManager.component(ofType: SpriteComponent.self, of: event.entityId) else {
            return
        }

        physicsComponent.velocity = .zero
        spriteComponent.textureAtlas = nil
    }

    private func getPhysicsComponent(of entityId: EntityId) -> PhysicsComponent? {
        entityManager.component(ofType: PhysicsComponent.self, of: entityId)
    }
 }
