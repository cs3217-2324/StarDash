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
        dispatcher?.registerListener(self)

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
        guard let positionSystem = dispatcher?.system(ofType: PositionSystem.self),
              let oldEndPoint = positionSystem.getPosition(of: hookEntityId),
              let hookComponent = getHookComponent(of: hookEntityId),
              let hookOwnerId = getHookOwner(of: hookEntityId),
              let ownerPosition = positionSystem.getPosition(of: hookOwnerId) else {
            return
        }

        let vector = GameConstants.Hook.deltaPositionVector
        let newEndPoint = CGPoint(x: oldEndPoint.x + vector.dx, y: oldEndPoint.y + vector.dy)
        hookComponent.startpoint = ownerPosition

        positionSystem.move(entityId: hookEntityId, to: newEndPoint)
    }

    func retractHook(of hookEntityId: EntityId) {
        guard let positionSystem = dispatcher?.system(ofType: PositionSystem.self),
              let hookOwnerId = getHookOwner(of: hookEntityId),
              let oldStartPoint = positionSystem.getPosition(of: hookOwnerId),
              let hookComponent = getHookComponent(of: hookEntityId) else {
            return
        }

        let vector = GameConstants.Hook.deltaPositionVector
        let newStartPoint = CGPoint(x: oldStartPoint.x + vector.dx, y: oldStartPoint.y + vector.dy)
        let lengthRetracted = hypot(vector.dx, vector.dy)

        hookComponent.startpoint = newStartPoint
        hookComponent.lengthToRetract -= lengthRetracted
        positionSystem.move(entityId: hookOwnerId, to: newStartPoint)
    }

    func swing(using hookEntityId: EntityId) {
        guard let positionSystem = dispatcher?.system(ofType: PositionSystem.self),
              let hookOwnerId = getHookOwner(of: hookEntityId),
              let endPoint = getEndPoint(of: hookEntityId),
              let startPoint = getStartPoint(of: hookEntityId),
              let hookComponent = getHookComponent(of: hookEntityId) else {
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

        hookComponent.startpoint = newStartPoint
        hookComponent.angleToSwing -= GameConstants.Hook.deltaAngle
        positionSystem.move(entityId: hookOwnerId, to: newStartPoint)
    }

    func length(of hookEntityId: EntityId) -> CGFloat {
        guard let startPoint = getStartPoint(of: hookEntityId),
              let endPoint = getEndPoint(of: hookEntityId) else {
            return 0
        }

        return hypot(endPoint.x - startPoint.x, endPoint.y - startPoint.y)
    }

    func getStartPoint(of hookEntityId: EntityId) -> CGPoint? {
        guard let grappleHookComponent = getHookComponent(of: hookEntityId) else {
            return nil
        }

        return grappleHookComponent.startpoint
    }

    func getEndPoint(of hookEntityId: EntityId) -> CGPoint? {
        guard let positionSystem = dispatcher?.system(ofType: PositionSystem.self),
              let hookPosition = positionSystem.getPosition(of: hookEntityId) else {
            return nil
        }

        return hookPosition
    }

    func adjustRope(of hookEntityId: EntityId) {
        guard let positionSystem = dispatcher?.system(ofType: PositionSystem.self),
              let physicsSystem = dispatcher?.system(ofType: PhysicsSystem.self),
              let spriteSystem = dispatcher?.system(ofType: SpriteSystem.self),
              let ropeId = getRopeId(of: hookEntityId),
              let startPoint = getStartPoint(of: hookEntityId),
              let endPoint = getEndPoint(of: hookEntityId) else {
            return
        }

        let newSize = CGSize(width: 10, height: length(of: hookEntityId) - 20)
        physicsSystem.setSize(of: ropeId, to: newSize)
        spriteSystem.setSize(of: ropeId, to: newSize)

        let midX = (startPoint.x + endPoint.x) / 2
        let midY = (startPoint.y + endPoint.y) / 2
        let newPosition = CGPoint(x: midX, y: midY)
        positionSystem.move(entityId: ropeId, to: newPosition)

        let deltaX = endPoint.x - startPoint.x
        let deltaY = endPoint.y - startPoint.y
        let angle = atan2(deltaY, deltaX) - (.pi / 2)
        positionSystem.rotate(entityId: ropeId, to: angle)
    }

    func getRopeId(of hookEntityId: EntityId) -> EntityId? {
        guard let ropeComponent = entityManager.component(ofType: OwnsRopeComponent.self,
                                                          of: hookEntityId) else {
            return nil
        }

        return ropeComponent.ropeId
    }

    func getHookOwner(of hookEntityId: EntityId) -> EntityId? {
        guard let hookOwnerComponent = entityManager.component(ofType: GrappleHookOwnerComponent.self,
                                                               of: hookEntityId) else {
            return nil
        }

        return hookOwnerComponent.ownerPlayerId
    }

    func lengthLeftToRetract(of hookEntityId: EntityId) -> CGFloat? {
        guard let hookComponent = getHookComponent(of: hookEntityId) else {
            return nil
        }

        return hookComponent.lengthToRetract
    }

    func angleLeftToSwing(of hookEntityId: EntityId) -> CGFloat? {
        guard let hookComponent = getHookComponent(of: hookEntityId) else {
            return nil
        }

        return hookComponent.angleToSwing
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

    private func activateHook(event: UseGrappleHookEvent) {
        guard let playerComponent = entityManager.component(ofType: PlayerComponent.self, of: event.playerId),
              playerComponent.canHook,
              let entityManager = dispatcher as? EntityManagerInterface,
              let positionSystem = dispatcher?.system(ofType: PositionSystem.self),
              let position = positionSystem.getPosition(of: event.playerId) else {
            return
        }

        playerComponent.canHook = false
        playerComponent.canMove = false
        playerComponent.canJump = false

        EntityFactory.createAndAddGrappleHook(to: entityManager,
                                              playerId: event.playerId,
                                              startpoint: position)
    }

    private func handleShootEvent(event: ShootGrappleHookEvent) {
        guard length(of: event.hookId) < GameConstants.Hook.maxLength else {
            setHookState(of: event.hookId, to: .releasing)
            return
        }

        extendHook(of: event.hookId)
        adjustRope(of: event.hookId)
    }

    private func handleRetractEvent(event: RetractGrappleHookEvent) {
        guard let lengthRemaining = lengthLeftToRetract(of: event.hookId),
              lengthRemaining > 0 else {
            setHookState(of: event.hookId, to: .swinging)
            return
        }

        retractHook(of: event.hookId)
        adjustRope(of: event.hookId)
    }

    private func handleSwingEvent(event: SwingGrappleHookEvent) {
        guard let angleRemaining = angleLeftToSwing(of: event.hookId),
              angleRemaining > 0 else {
            setHookState(of: event.hookId, to: .releasing)
            return
        }

        swing(using: event.hookId)
        adjustRope(of: event.hookId)
    }

    private func handleReleaseEvent(event: ReleaseGrappleHookEvent) {
        guard let playerOwnerId = getHookOwner(of: event.hookId),
              let playerComponent = entityManager.component(ofType: PlayerComponent.self, of: playerOwnerId),
              let ropeId = getRopeId(of: event.hookId) else {
            return
        }

        playerComponent.canHook = true
        playerComponent.canJump = true
        playerComponent.canMove = true

        dispatcher?.add(event: RemoveEvent(on: ropeId))
        dispatcher?.add(event: RemoveEvent(on: event.hookId))
    }

    private func getHookComponent(of entityId: EntityId) -> GrappleHookComponent? {
        entityManager.component(ofType: GrappleHookComponent.self, of: entityId)
    }
}
