//
//  GrappleHookSystem.swift
//  star-dash
//
//  Created by Ho Jun Hao on 18/3/24.
//

import Foundation

class GrappleHookSystem: System {
    var isActive: Bool
    var dispatcher: EventModifiable?
    var entityManager: EntityManager
    var stateHandler: [HookState: (EntityId) -> Void] = [:]

    init(_ entityManager: EntityManager, dispatcher: EventModifiable? = nil) {
        self.isActive = true
        self.dispatcher = dispatcher
        self.entityManager = entityManager
        self.stateHandler = [
            .shooting: handleShooting,
            .retracting: handleRetracting,
            .swinging: handleSwinging,
            .releasing: handleReleasing
        ]
    }

    func update(by deltaTime: TimeInterval) {
        let hookEntities = entityManager.components(ofType: HookEquippedComponent.self)

        for hookEntity in hookEntities {
            guard let hookComponent = getHookComponent(of: hookEntity.id) else {
                continue
            }

            guard let hookHandler = stateHandler[hookComponent.state] else {
                continue
            }

            hookHandler(hookEntity.id)
        }
    }

    func activateHook(at position: CGPoint, ownedBy playerId: EntityId) {
        let hookEntity = GrappleHook(startPoint: position, endPoint: position, playerId: playerId)
        hookEntity.setUpAndAdd(to: entityManager)

        let hookEquippedComponent = HookEquippedComponent(entityId: playerId, hookId: hookEntity.id)
        entityManager.add(component: hookEquippedComponent)

        guard let hookComponent = getHookComponent(of: hookEntity.id) else {
            return
        }

        hookComponent.state = .shooting
    }

    func extendHook(of hookEntityId: EntityId) {
        guard let hookPhysicsComponent = entityManager.component(ofType: PhysicsComponent.self,
                                                                 of: hookEntityId),
              hookPhysicsComponent.shape == .line,
              let oldEndPoint = hookPhysicsComponent.endPoint else {
            return
        }

        let vector = GameConstants.Hook.deltaPositionVector
        let newEndPoint = CGPoint(x: oldEndPoint.x + vector.dx, y: oldEndPoint.y + vector.dy)

        hookPhysicsComponent.endPoint = newEndPoint
    }

    func retractHook(of hookEntityId: EntityId) {
        guard let hookPhysicsComponent = entityManager.component(ofType: PhysicsComponent.self,
                                                                 of: hookEntityId),
              hookPhysicsComponent.shape == .line,
              let oldStartPoint = hookPhysicsComponent.startPoint,
              let hookComponent = getHookComponent(of: hookEntityId) else {
            return
        }

        let vector = GameConstants.Hook.deltaPositionVector
        let newStartPoint = CGPoint(x: oldStartPoint.x + vector.dx, y: oldStartPoint.y + vector.dy)
        let lengthRetracted = sqrt(pow(vector.dx, 2) + pow(vector.dy, 2))

        hookComponent.lengthToRetract -= lengthRetracted
        hookPhysicsComponent.startPoint = newStartPoint
    }

    func length(of hookEntityId: EntityId) -> CGFloat {
        guard let hookPhysicsComponent = entityManager.component(ofType: PhysicsComponent.self,
                                                                 of: hookEntityId),
              hookPhysicsComponent.shape == .line,
              let endPoint = hookPhysicsComponent.endPoint,
              let startPoint = hookPhysicsComponent.startPoint else {
            return 0
        }

        return sqrt(pow(endPoint.x - startPoint.x, 2) + pow(endPoint.y - startPoint.y, 2))
    }

    func getStartPoint(of hookEntityId: EntityId) -> CGPoint? {
        guard let hookPhysicsComponent = entityManager.component(ofType: PhysicsComponent.self,
                                                                 of: hookEntityId),
              hookPhysicsComponent.shape == .line else {
            return nil
        }

        return hookPhysicsComponent.startPoint
    }

    func getPlayerReleaseImpulse(of hookEntityId: EntityId) -> CGVector? {
        guard let hookPhysicsComponent = entityManager.component(ofType: PhysicsComponent.self,
                                                                 of: hookEntityId),
              hookPhysicsComponent.shape == .line,
              let endPoint = hookPhysicsComponent.endPoint,
              let startPoint = hookPhysicsComponent.startPoint else {
            return nil
        }

        let dx = endPoint.x - startPoint.x
        let dy = endPoint.y - startPoint.y
        let normalX = -dy
        let normalY = dx
        let length = hypot(normalX, normalY)
        let unitNormalX = normalX / length
        let unitNormalY = normalY / length
        let impulseVector = CGVector(dx: unitNormalX, dy: unitNormalY) * GameConstants.Hook.releaseImpulseMagnitude

        return impulseVector
    }

    func getHookOwner(of hookEntityId: EntityId) -> EntityId? {
        guard let hookOwnerComponent = entityManager.component(ofType: HookOwnerComponent.self,
                                                               of: hookEntityId) else {
            return nil
        }

        return hookOwnerComponent.playerId
    }

    func lengthLeftToRetract(of hookEntityId: EntityId) -> CGFloat? {
        guard let hookComponent = getHookComponent(of: hookEntityId) else {
            return nil
        }

        return hookComponent.lengthToRetract
    }

    func setHookState(of hookEntityId: EntityId, to state: HookState) {
        guard let hookComponent = getHookComponent(of: hookEntityId) else {
            return
        }

        hookComponent.state = state
    }

    func getHookState(of hookEntityId: EntityId) -> HookState? {
        guard let hookComponent = getHookComponent(of: hookEntityId) else {
            return nil
        }

        return hookComponent.state
    }

    func swing(using hookEntityId: EntityId) {
        guard let hookPhysicsComponent = entityManager.component(ofType: PhysicsComponent.self,
                                                                 of: hookEntityId),
              hookPhysicsComponent.shape == .line,
              let endPoint = hookPhysicsComponent.endPoint,
              let startPoint = hookPhysicsComponent.startPoint else {
            return
        }

        let dx = startPoint.x - endPoint.x
        let dy = startPoint.y - endPoint.y
        let distance = hypot(dx, dy)
        let angle = atan2(dy, dx)
        let newAngle = angle + GameConstants.Hook.deltaAngle * .pi / 180.0
        let newX = endPoint.x + distance * cos(newAngle)
        let newY = endPoint.y + distance * sin(newAngle)
        let newStartPoint = CGPoint(x: newX, y: newY)

        hookPhysicsComponent.startPoint = newStartPoint
    }

    func angleLeftToSwing(of hookEntityId: EntityId) -> CGFloat? {
        guard let hookComponent = getHookComponent(of: hookEntityId) else {
            return nil
        }

        return hookComponent.angleToSwing
    }

    private func handleShooting(_ hookId: EntityId) {
        let shootEvent = ShootGrappleHookEvent(using: hookId)
        dispatcher?.add(event: shootEvent)
    }

    private func handleRetracting(_ hookId: EntityId) {
        let retractEvent = RetractGrappleHookEvent(using: hookId)
        dispatcher?.add(event: retractEvent)
    }

    private func handleSwinging(_ hookId: EntityId) {
        let swingEvent = SwingGrappleHookEvent(using: hookId)
        dispatcher?.add(event: swingEvent)
    }

    private func handleReleasing(_ hookId: EntityId) {
        let releaseEvent = ReleaseGrappleHookEvent(using: hookId)
        dispatcher?.add(event: releaseEvent)
    }

    private func getHookComponent(of entityId: EntityId) -> GrappleHookComponent? {
        entityManager.component(ofType: GrappleHookComponent.self, of: entityId)
    }
}
