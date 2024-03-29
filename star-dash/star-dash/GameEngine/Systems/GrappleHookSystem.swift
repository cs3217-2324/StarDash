//
//  GrappleHookSystem.swift
//  star-dash
//
//  Created by Ho Jun Hao on 28/3/24.
//

import Foundation

class GrappleHookSystem: System {
    var isActive: Bool
    var dispatcher: EventModifiable?
    var entityManager: EntityManager
    var stateHandler: [HookState: (EntityId) -> Event] = [:]
    var eventHandlers: [ObjectIdentifier: (Event) -> Void] = [:]

    init(_ entityManager: EntityManager, dispatcher: EventModifiable? = nil) {
        self.isActive = true
        self.dispatcher = dispatcher
        self.entityManager = entityManager
        self.stateHandler = [
             .shooting: { entityId in
                 ShootGrappleHookEvent(using: entityId)
             },
             .retracting: { entityId in
                 RetractGrappleHookEvent(using: entityId)
             },
             .swinging: { entityId in
                 SwingGrappleHookEvent(using: entityId)
             },
             .releasing: { entityId in
                 ReleaseGrappleHookEvent(using: entityId)
             }
         ]
        setup()
    }

    func update(by deltaTime: TimeInterval) {
        let hookEntities = entityManager.entities(ofType: GrappleHook.self)

        for hookEntity in hookEntities {
            guard let hookComponent = getHookComponent(of: hookEntity.id),
                  let hookHandler = stateHandler[hookComponent.state] else {
                continue
            }

            let event = hookHandler(hookEntity.id)

            dispatcher?.add(event: event)
        }
    }

    func setup() {
        dispatcher?.registerListener(for: UseGrappleHookEvent.self, listener: self)
        dispatcher?.registerListener(for: ShootGrappleHookEvent.self, listener: self)
        dispatcher?.registerListener(for: RetractGrappleHookEvent.self, listener: self)
        dispatcher?.registerListener(for: SwingGrappleHookEvent.self, listener: self)
        dispatcher?.registerListener(for: ReleaseGrappleHookEvent.self, listener: self)

        eventHandlers[ObjectIdentifier(UseGrappleHookEvent.self)] = { event in
            if let useGrappleHookEvent = event as? UseGrappleHookEvent {
                self.activateHook(event: useGrappleHookEvent)
            }
        }
        eventHandlers[ObjectIdentifier(ShootGrappleHookEvent.self)] = { event in
            if let shootGrappleHookEvent = event as? ShootGrappleHookEvent {
                self.handleShootEvent(event: shootGrappleHookEvent)
            }
        }
        eventHandlers[ObjectIdentifier(RetractGrappleHookEvent.self)] = { event in
            if let playerAttackMonsterEvent = event as? RetractGrappleHookEvent {
                self.handleRetractEvent(event: playerAttackMonsterEvent)
            }
        }
        eventHandlers[ObjectIdentifier(SwingGrappleHookEvent.self)] = { event in
            if let monsterAttackPlayerEvent = event as? SwingGrappleHookEvent {
                self.handleSwingEvent(event: monsterAttackPlayerEvent)
            }
        }
        eventHandlers[ObjectIdentifier(ReleaseGrappleHookEvent.self)] = { event in
            if let playerAttackMonsterEvent = event as? ReleaseGrappleHookEvent {
                self.handleReleaseEvent(event: playerAttackMonsterEvent)
            }
        }
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
        guard let hookOwnerComponent = entityManager.component(ofType: GrappleHookOwnerComponent.self,
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

    private func activateHook(event: UseGrappleHookEvent) {
        guard let entityManager = dispatcher as? EntityManagerInterface else {
            return
        }

        EntityFactory.createAndAddGrappleHook(to: entityManager,
                                              playerId: event.playerId,
                                              startpoint: event.position,
                                              endpoint: event.position)
    }

    private func handleShootEvent(event: ShootGrappleHookEvent) {
        guard length(of: event.hookId) >= GameConstants.Hook.maxLength else {
            extendHook(of: event.hookId)
            return
        }

        setHookState(of: event.hookId, to: .releasing)
    }

    private func handleRetractEvent(event: RetractGrappleHookEvent) {
        guard let positionSystem = dispatcher?.system(ofType: PositionSystem.self),
              let hookOwnerId = getHookOwner(of: event.hookId) else {
            return
        }

        guard let lengthRemaining = lengthLeftToRetract(of: event.hookId),
              lengthRemaining > 0 else {
            setHookState(of: event.hookId, to: .swinging)
            return
        }

        retractHook(of: event.hookId)

        guard let startPointOfHook = getStartPoint(of: event.hookId) else {
            return
        }

        positionSystem.move(entityId: hookOwnerId, to: startPointOfHook)
    }

    private func handleSwingEvent(event: SwingGrappleHookEvent) {
        guard let positionSystem = dispatcher?.system(ofType: PositionSystem.self),
              let hookOwnerId = getHookOwner(of: event.hookId) else {
            return
        }

        guard let angleRemaining = angleLeftToSwing(of: event.hookId),
              angleRemaining > 0 else {
            setHookState(of: event.hookId, to: .releasing)
            return
        }

        swing(using: event.hookId)

        guard let startPointOfHook = getStartPoint(of: event.hookId) else {
            return
        }

        positionSystem.move(entityId: hookOwnerId, to: startPointOfHook)
    }

    private func handleReleaseEvent(event: ReleaseGrappleHookEvent) {
        guard let playerReleaseImpulse = getPlayerReleaseImpulse(of: event.hookId),
              let playerOwnerId = getHookOwner(of: event.hookId),
              let physicsSystem = dispatcher?.system(ofType: PhysicsSystem.self),
              let playerComponent = entityManager.component(ofType: PlayerComponent.self, of: playerOwnerId) else {
            return
        }

        playerComponent.canJump = true
        playerComponent.canMove = true
        physicsSystem.applyImpulse(to: playerOwnerId, impulse: playerReleaseImpulse)

        dispatcher?.add(event: RemoveEvent(on: event.hookId))
    }

    private func getHookComponent(of entityId: EntityId) -> GrappleHookComponent? {
        entityManager.component(ofType: GrappleHookComponent.self, of: entityId)
    }
}
