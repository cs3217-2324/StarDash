//
//  ToolSystem.swift
//  star-dash
//
//  Created by Ho Jun Hao on 18/3/24.
//

import Foundation

class ToolSystem: System {
    var isActive: Bool
    var dispatcher: EventModifiable?
    var entityManager: EntityManager
    var stateHandler: [ToolState: (EntityId) -> Void] = [:]

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
        let toolEntities = entityManager.components(ofType: ToolEquipedComponent.self)

        for toolEntity in toolEntities {
            guard let toolComponent = getToolComponent(of: toolEntity.id) else {
                continue
            }

            guard let toolHandler = stateHandler[toolComponent.state] else {
                continue
            }

            toolHandler(toolEntity.id)
        }
    }

    func activateTool(at position: CGPoint, ownedBy playerId: EntityId) {
        let toolEntity = Tool(startPoint: position, endPoint: position, playerId: playerId)
        toolEntity.setUpAndAdd(to: entityManager)

        let toolEquippedComponent = ToolEquipedComponent(entityId: playerId, toolId: toolEntity.id)
        entityManager.add(component: toolEquippedComponent)

        guard let toolComponent = getToolComponent(of: toolEntity.id) else {
            return
        }

        toolComponent.state = .shooting
    }

    func extendTool(of toolEntityId: EntityId) {
        guard let toolPhysicsComponent = entityManager.component(ofType: PhysicsComponent.self,
                                                                 of: toolEntityId),
              toolPhysicsComponent.shape == .line,
              let oldEndPoint = toolPhysicsComponent.endPoint else {
            return
        }

        let vector = ToolComponent.toolShootVector
        let newEndPoint = CGPoint(x: oldEndPoint.x + vector.dx, y: oldEndPoint.y + vector.dy)

        toolPhysicsComponent.endPoint = newEndPoint
    }

    func retractTool(of toolEntityId: EntityId) {
        guard let toolPhysicsComponent = entityManager.component(ofType: PhysicsComponent.self,
                                                                 of: toolEntityId),
              toolPhysicsComponent.shape == .line,
              let oldStartPoint = toolPhysicsComponent.startPoint,
              let toolComponent = getToolComponent(of: toolEntityId) else {
            return
        }

        let vector = ToolComponent.toolShootVector
        let newStartPoint = CGPoint(x: oldStartPoint.x + vector.dx, y: oldStartPoint.y + vector.dy)
        let lengthRetracted = sqrt(pow(vector.dx, 2) + pow(vector.dy, 2))

        toolComponent.lengthToRetract -= lengthRetracted
        toolPhysicsComponent.startPoint = newStartPoint
    }

    func length(of toolEntityId: EntityId) -> CGFloat {
        guard let toolPhysicsComponent = entityManager.component(ofType: PhysicsComponent.self,
                                                                 of: toolEntityId),
              toolPhysicsComponent.shape == .line,
              let endPoint = toolPhysicsComponent.endPoint,
              let startPoint = toolPhysicsComponent.startPoint else {
            return 0
        }

        return sqrt(pow(endPoint.x - startPoint.x, 2) + pow(endPoint.y - startPoint.y, 2))
    }

    func getStartPoint(of toolEntityId: EntityId) -> CGPoint? {
        guard let toolPhysicsComponent = entityManager.component(ofType: PhysicsComponent.self,
                                                                 of: toolEntityId),
              toolPhysicsComponent.shape == .line else {
            return nil
        }

        return toolPhysicsComponent.startPoint
    }

    func getPlayerReleaseImpulse(of toolEntityId: EntityId) -> CGVector? {
        guard let toolPhysicsComponent = entityManager.component(ofType: PhysicsComponent.self,
                                                                 of: toolEntityId),
              toolPhysicsComponent.shape == .line,
              let endPoint = toolPhysicsComponent.endPoint,
              let startPoint = toolPhysicsComponent.startPoint else {
            return nil
        }

        let dx = endPoint.x - startPoint.x
        let dy = endPoint.y - startPoint.y
        let normalX = -dy
        let normalY = dx
        let length = hypot(normalX, normalY)
        let unitNormalX = normalX / length
        let unitNormalY = normalY / length
        let impulseVector = CGVector(dx: unitNormalX, dy: unitNormalY) * ToolComponent.releaseImpulseMagnitude

        return impulseVector
    }

    func getToolOwner(of toolEntityId: EntityId) -> EntityId? {
        guard let toolOwnerComponent = entityManager.component(ofType: ToolOwnerComponent.self,
                                                               of: toolEntityId) else {
            return nil
        }

        return toolOwnerComponent.playerId
    }

    func lengthLeftToRetract(of toolEntityId: EntityId) -> CGFloat? {
        guard let toolComponent = getToolComponent(of: toolEntityId) else {
            return nil
        }

        return toolComponent.lengthToRetract
    }

    func setToolState(of toolEntityId: EntityId, to state: ToolState) {
        guard let toolComponent = getToolComponent(of: toolEntityId) else {
            return
        }

        toolComponent.state = state
    }

    func getToolState(of toolEntityId: EntityId) -> ToolState? {
        guard let toolComponent = getToolComponent(of: toolEntityId) else {
            return nil
        }

        return toolComponent.state
    }

    func swing(using toolEntityId: EntityId) {
        guard let toolPhysicsComponent = entityManager.component(ofType: PhysicsComponent.self,
                                                                 of: toolEntityId),
              toolPhysicsComponent.shape == .line,
              let endPoint = toolPhysicsComponent.endPoint,
              let startPoint = toolPhysicsComponent.startPoint else {
            return
        }

        let dx = startPoint.x - endPoint.x
        let dy = startPoint.y - endPoint.y
        let distance = hypot(dx, dy)
        let angle = atan2(dy, dx)
        let newAngle = angle + ToolComponent.angleMoved * .pi / 180.0
        let newX = endPoint.x + distance * cos(newAngle)
        let newY = endPoint.y + distance * sin(newAngle)
        let newStartPoint = CGPoint(x: newX, y: newY)

        toolPhysicsComponent.startPoint = newStartPoint
    }

    func angleLeftToSwing(of toolEntityId: EntityId) -> CGFloat? {
        guard let toolComponent = getToolComponent(of: toolEntityId) else {
            return nil
        }

        return toolComponent.angleToSwing
    }

    private func handleShooting(_ toolId: EntityId) {
        let shootEvent = ShootGrappleHookEvent(using: toolId)
        dispatcher?.add(event: shootEvent)
    }

    private func handleRetracting(_ toolId: EntityId) {
        let retractEvent = RetractGrappleHookEvent(using: toolId)
        dispatcher?.add(event: retractEvent)
    }

    private func handleSwinging(_ toolId: EntityId) {
        let swingEvent = SwingGrappleHookEvent(using: toolId)
        dispatcher?.add(event: swingEvent)
    }

    private func handleReleasing(_ toolId: EntityId) {
        let releaseEvent = ReleaseGrappleHookEvent(using: toolId)
        dispatcher?.add(event: releaseEvent)
    }

    private func getToolComponent(of entityId: EntityId) -> ToolComponent? {
        entityManager.component(ofType: ToolComponent.self, of: entityId)
    }
}
