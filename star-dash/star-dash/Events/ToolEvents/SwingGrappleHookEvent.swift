//
//  SwingGrappleHookEvent.swift
//  star-dash
//
//  Created by Ho Jun Hao on 18/3/24.
//

import Foundation

class SwingGrappleHookEvent: Event {
    let timestamp: Date
    let entityId: EntityId

    init(using hookEntityId: EntityId) {
        self.timestamp = Date.now
        entityId = hookEntityId
    }

    func execute(on target: EventModifiable) {
        // swing from one point to another point about the end point (pivot)
        // move player along
        // once reached the end of arc set to release
        guard let hookSystem = target.system(ofType: GrappleHookSystem.self),
              let positionSystem = target.system(ofType: PositionSystem.self),
              let hookOwnerId = hookSystem.getHookOwner(of: entityId) else {
            return
        }

        guard let angleRemaining = hookSystem.angleLeftToSwing(of: entityId),
              angleRemaining > 0 else {
            hookSystem.setHookState(of: entityId, to: .releasing)
            return
        }

        hookSystem.swing(using: entityId)

        guard let startPointOfHook = hookSystem.getStartPoint(of: entityId) else {
            return
        }

        positionSystem.move(entityId: hookOwnerId, to: startPointOfHook)
    }
}
