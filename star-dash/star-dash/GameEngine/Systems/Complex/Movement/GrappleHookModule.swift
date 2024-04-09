import Foundation

class GrappleHookModule: MovementModule {
    let entityManager: EntityManager
    let dispatcher: EventModifiable?

    var eventHandlers: [ObjectIdentifier: (Event) -> Event?] = [:]
    lazy var listenableEvents: [ObjectIdentifier] = Array(eventHandlers.keys)

    var stateHandler: [HookState: (EntityId) -> Event] = [
        .shooting: { entityId in ShootGrappleHookEvent(using: entityId) },
        .retracting: { entityId in RetractGrappleHookEvent(using: entityId) },
        .swinging: { entityId in SwingGrappleHookEvent(using: entityId) },
        .releasing: { entityId in ReleaseGrappleHookEvent(using: entityId) }
    ]

    init(entityManager: EntityManager, dispatcher: EventModifiable?) {
        self.entityManager = entityManager
        self.dispatcher = dispatcher

        eventHandlers[ObjectIdentifier(UseGrappleHookEvent.self)] = { event in
            if let useGrappleHookEvent = event as? UseGrappleHookEvent {
                return self.activateHook(event: useGrappleHookEvent)
            }
            return nil
        }
        eventHandlers[ObjectIdentifier(ShootGrappleHookEvent.self)] = { event in
            if let shootGrappleHookEvent = event as? ShootGrappleHookEvent {
                return self.handleShootEvent(event: shootGrappleHookEvent)
            }
            return nil
        }
        eventHandlers[ObjectIdentifier(RetractGrappleHookEvent.self)] = { event in
            if let playerAttackMonsterEvent = event as? RetractGrappleHookEvent {
                return self.handleRetractEvent(event: playerAttackMonsterEvent)
            }
            return nil
        }
        eventHandlers[ObjectIdentifier(SwingGrappleHookEvent.self)] = { event in
            if let monsterAttackPlayerEvent = event as? SwingGrappleHookEvent {
                return self.handleSwingEvent(event: monsterAttackPlayerEvent)
            }
            return nil
        }
        eventHandlers[ObjectIdentifier(ReleaseGrappleHookEvent.self)] = { event in
            if let playerAttackMonsterEvent = event as? ReleaseGrappleHookEvent {
                return self.handleReleaseEvent(event: playerAttackMonsterEvent)
            }
            return nil
        }
        eventHandlers[ObjectIdentifier(PlayerObstacleContactEvent.self)] = { event in
            if let playerObstacleContactEvent = event as? PlayerObstacleContactEvent {
                return self.handlePlayerObstacleContactEvent(event: playerObstacleContactEvent)
            }
            return nil
        }
        eventHandlers[ObjectIdentifier(GrappleHookObstacleContactEvent.self)] = { event in
            if let grappleHookObstacleContactEvent = event as? GrappleHookObstacleContactEvent {
                return self.handleGrappleHookObstacleContactEvent(event: grappleHookObstacleContactEvent)
            }
            return nil
        }
    }

    func update(by deltaTime: TimeInterval) {
        let hookEntities = entityManager.entities(ofType: GrappleHook.self)

        for hookEntity in hookEntities {
            guard let hookComponent = getHookComponent(of: hookEntity.id),
                  let hookHandler = stateHandler[hookComponent.state] else {
                continue
            }

            dispatcher?.add(event: hookHandler(hookEntity.id))
        }
    }

    func handleEvent(_ event: Event) -> Event? {
        let eventType = ObjectIdentifier(type(of: event))
        if let handler = eventHandlers[eventType] {
            return handler(event)
        }

        guard let playerId = event.playerIdForEvent,
              let hookOwnerComponent = entityManager.components(ofType: GrappleHookOwnerComponent.self)
                                                    .first(where: { $0.ownerPlayerId == playerId }),
              let hookState = getHookState(of: hookOwnerComponent.entityId) else {
            return event // player is hooking, block event
        }

        return nil
    }

    func extendHook(of hookEntityId: EntityId) {
        guard let positionSystem = dispatcher?.system(ofType: PositionSystem.self),
              let oldEndPoint = positionSystem.getPosition(of: hookEntityId),
              let hookComponent = getHookComponent(of: hookEntityId),
              let hookOwnerId = getHookOwner(of: hookEntityId),
              let ownerPosition = positionSystem.getPosition(of: hookOwnerId) else {
            return
        }

        let vector = hookComponent.isLeft
        ? GameConstants.Hook.deltaPositionVectorLeft
        : GameConstants.Hook.deltaPositionVectorRight
        let newEndPoint = CGPoint(x: oldEndPoint.x + vector.dx, y: oldEndPoint.y + vector.dy)
        hookComponent.startpoint = ownerPosition

        positionSystem.move(entityId: hookEntityId, to: newEndPoint)
    }

    func retractHook(of hookEntityId: EntityId) {
        guard let positionSystem = dispatcher?.system(ofType: PositionSystem.self),
              let hookOwnerId = getHookOwner(of: hookEntityId),
              let oldStartPoint = getStartPoint(of: hookEntityId),
              let hookComponent = getHookComponent(of: hookEntityId) else {
            return
        }

        let vector = hookComponent.isLeft
        ? GameConstants.Hook.deltaPositionVectorLeft
        : GameConstants.Hook.deltaPositionVectorRight
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
        var newAngle: CGFloat
        if hookComponent.isLeft {
            newAngle = angle - GameConstants.Hook.deltaAngle * .pi / 180.0
        } else {
            newAngle = angle + GameConstants.Hook.deltaAngle * .pi / 180.0
        }
        let newX = endPoint.x + distance * cos(newAngle)
        let newY = endPoint.y + distance * sin(newAngle)
        let newStartPoint = CGPoint(x: newX, y: newY)

        hookComponent.startpoint = newStartPoint
        hookComponent.angleToSwing -= GameConstants.Hook.deltaAngle
        positionSystem.move(entityId: hookOwnerId, to: newStartPoint)
    }

    func setSwingAngle(for hookEntityId: EntityId) {
        guard let hookPosition = getEndPoint(of: hookEntityId),
              let currPosition = getStartPoint(of: hookEntityId),
              let hookComponent = getHookComponent(of: hookEntityId) else {
            return
        }

        let firePosition = hookComponent.shootPoint

        let dx = firePosition.x - hookPosition.x
        let dy = firePosition.y - hookPosition.y
        let distance = hypot(dx, dy)
        let angle = atan2(dy, dx)
        var newAngle: CGFloat
        if hookComponent.isLeft {
            newAngle = angle - GameConstants.Hook.defaultSwingAngle * .pi / 180.0
        } else {
            newAngle = angle + GameConstants.Hook.defaultSwingAngle * .pi / 180.0
        }
        let newX = hookPosition.x + distance * cos(newAngle)
        let newY = hookPosition.y + distance * sin(newAngle)
        let eventualSwingEndPoint = CGPoint(x: newX, y: newY)

        let angleToSwing = angleBetweenPoints(S: hookPosition, P: currPosition, E: eventualSwingEndPoint)

        hookComponent.angleToSwing = angleToSwing
    }

    func length(of hookEntityId: EntityId) -> CGFloat {
        guard let startPoint = getStartPoint(of: hookEntityId),
              let endPoint = getEndPoint(of: hookEntityId) else {
            return 0
        }

        return hypot(endPoint.x - startPoint.x, endPoint.y - startPoint.y)
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

    private func activateHook(event: UseGrappleHookEvent) -> Event? {
        guard let positionSystem = dispatcher?.system(ofType: PositionSystem.self),
              let position = positionSystem.getPosition(of: event.playerId),
              getHookState(of: event.playerId) == nil else {
            return nil
        }

        EntityFactory.createAndAddGrappleHook(to: entityManager,
                                              playerId: event.playerId,
                                              isLeft: event.isLeft,
                                              startpoint: position)
        return nil
    }

    private func handleShootEvent(event: ShootGrappleHookEvent) -> Event? {
        guard length(of: event.hookId) < GameConstants.Hook.maxLength else {
            setHookState(of: event.hookId, to: .releasing)
            return nil
        }

        extendHook(of: event.hookId)
        adjustRope(of: event.hookId)
        return nil
    }

    private func handleRetractEvent(event: RetractGrappleHookEvent) -> Event? {
        guard let lengthRemaining = lengthLeftToRetract(of: event.hookId),
              lengthRemaining > 0 else {
            setHookState(of: event.hookId, to: .swinging)
            return nil
        }

        retractHook(of: event.hookId)
        adjustRope(of: event.hookId)
        return nil
    }

    private func handleSwingEvent(event: SwingGrappleHookEvent) -> Event? {
        guard let angleRemaining = angleLeftToSwing(of: event.hookId),
              angleRemaining > 0 else {
            setHookState(of: event.hookId, to: .releasing)
            return nil
        }

        swing(using: event.hookId)
        adjustRope(of: event.hookId)
        return nil
    }

    private func handleReleaseEvent(event: ReleaseGrappleHookEvent) -> Event? {
        guard let ropeId = getRopeId(of: event.hookId) else {
            return nil
        }

        dispatcher?.add(event: RemoveEvent(on: ropeId))
        dispatcher?.add(event: RemoveEvent(on: event.hookId))
        return nil
    }

    private func handlePlayerObstacleContactEvent(event: PlayerObstacleContactEvent) -> Event? {
        guard let hookOwnerComponent = entityManager
            .components(ofType: GrappleHookOwnerComponent.self)
            .first(where: { $0.ownerPlayerId == event.playerId }) else {
            return event
        }

        dispatcher?.add(event: ReleaseGrappleHookEvent(using: hookOwnerComponent.entityId))
        return event
    }

    private func handleGrappleHookObstacleContactEvent(event: GrappleHookObstacleContactEvent) -> Event? {
        guard let hookState = getHookState(of: event.grappleHookId) else {
            return nil
        }

        setSwingAngle(for: event.grappleHookId)

        guard hookState == .shooting else {
            return nil
        }

        if length(of: event.grappleHookId) >= GameConstants.Hook.minLength {
            setHookState(of: event.grappleHookId, to: .retracting)
        } else {
            dispatcher?.add(event: ReleaseGrappleHookEvent(using: event.grappleHookId))
        }
        return nil
    }

    private func getHookComponent(of entityId: EntityId) -> GrappleHookComponent? {
        entityManager.component(ofType: GrappleHookComponent.self, of: entityId)
    }
}

extension GrappleHookModule {
    private func angleBetweenPoints(S: CGPoint, P: CGPoint, E: CGPoint) -> CGFloat {
        let SP = distanceBetweenPoints(S, P)
        let SE = distanceBetweenPoints(S, E)
        let PE = distanceBetweenPoints(P, E)

        let cosAngle = (SP * SP + SE * SE - PE * PE) / (2 * SP * SE)
        let angle = acos(cosAngle)
        return angle * 180 / .pi
    }

    private func distanceBetweenPoints(_ a: CGPoint, _ b: CGPoint) -> CGFloat {
        let dx = b.x - a.x
        let dy = b.y - a.y
        return sqrt(dx * dx + dy * dy)
    }

    private func lengthLeftToRetract(of hookEntityId: EntityId) -> CGFloat? {
        guard let hookComponent = getHookComponent(of: hookEntityId) else {
            return nil
        }

        return hookComponent.lengthToRetract
    }

    private func angleLeftToSwing(of hookEntityId: EntityId) -> CGFloat? {
        guard let hookComponent = getHookComponent(of: hookEntityId) else {
            return nil
        }

        return hookComponent.angleToSwing
    }

    private func getHookOwner(of hookEntityId: EntityId) -> EntityId? {
        guard let hookOwnerComponent = entityManager.component(ofType: GrappleHookOwnerComponent.self,
                                                               of: hookEntityId) else {
            return nil
        }

        return hookOwnerComponent.ownerPlayerId
    }

    private func adjustRope(of hookEntityId: EntityId) {
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

    private func getRopeId(of hookEntityId: EntityId) -> EntityId? {
        guard let ropeComponent = entityManager.component(ofType: OwnsRopeComponent.self,
                                                          of: hookEntityId) else {
            return nil
        }

        return ropeComponent.ropeId
    }

    private func getStartPoint(of hookEntityId: EntityId) -> CGPoint? {
        guard let grappleHookComponent = getHookComponent(of: hookEntityId) else {
            return nil
        }

        return grappleHookComponent.startpoint
    }

    private func getEndPoint(of hookEntityId: EntityId) -> CGPoint? {
        guard let positionSystem = dispatcher?.system(ofType: PositionSystem.self),
              let hookPosition = positionSystem.getPosition(of: hookEntityId) else {
            return nil
        }

        return hookPosition
    }
}