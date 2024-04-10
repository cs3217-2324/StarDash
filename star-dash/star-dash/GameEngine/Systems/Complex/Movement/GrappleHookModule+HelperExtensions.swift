//
//  GrappleHookModule+HelperExtensions.swift
//  star-dash
//
//  Created by Ho Jun Hao on 10/4/24.
//

import Foundation

extension GrappleHookModule {
    func getHookComponent(of entityId: EntityId) -> GrappleHookComponent? {
        entityManager.component(ofType: GrappleHookComponent.self, of: entityId)
    }

    func length(of hookEntityId: EntityId) -> CGFloat {
        guard let startPoint = getStartPoint(of: hookEntityId),
              let endPoint = getEndPoint(of: hookEntityId) else {
            return 0
        }

        return hypot(endPoint.x - startPoint.x, endPoint.y - startPoint.y)
    }

    func getHookState(of hookEntityId: EntityId) -> HookState? {
        guard let hookComponent = getHookComponent(of: hookEntityId) else {
            return nil
        }

        return hookComponent.state
    }

    func angleBetweenPoints(S: CGPoint, P: CGPoint, E: CGPoint) -> CGFloat {
        let SP = distanceBetweenPoints(S, P)
        let SE = distanceBetweenPoints(S, E)
        let PE = distanceBetweenPoints(P, E)

        let cosAngle = (SP * SP + SE * SE - PE * PE) / (2 * SP * SE)
        let angle = acos(cosAngle)
        return angle * 180 / .pi
    }

    func distanceBetweenPoints(_ a: CGPoint, _ b: CGPoint) -> CGFloat {
        let dx = b.x - a.x
        let dy = b.y - a.y
        return sqrt(dx * dx + dy * dy)
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

    func getHookOwner(of hookEntityId: EntityId) -> EntityId? {
        guard let hookOwnerComponent = entityManager.component(ofType: GrappleHookOwnerComponent.self,
                                                               of: hookEntityId) else {
            return nil
        }

        return hookOwnerComponent.ownerPlayerId
    }

    func hasHook(playerEntityId: EntityId) -> Bool {
        let hookOwnerComponents = entityManager.components(ofType: GrappleHookOwnerComponent.self)
        return hookOwnerComponents.contains(where: { $0.ownerPlayerId == playerEntityId })
    }

    func getRopeId(of hookEntityId: EntityId) -> EntityId? {
        guard let ropeComponent = entityManager.component(ofType: OwnsRopeComponent.self,
                                                          of: hookEntityId) else {
            return nil
        }

        return ropeComponent.ropeId
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
}
