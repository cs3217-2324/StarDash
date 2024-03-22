//
//  RetractGrappleHookEvent.swift
//  star-dash
//
//  Created by Ho Jun Hao on 18/3/24.
//

import Foundation

class RetractGrappleHookEvent: Event {
    let timestamp: Date
    let entityId: EntityId

    init(using hookEntityId: EntityId) {
        self.timestamp = Date.now
        entityId = hookEntityId
    }

    func execute(on target: EventModifiable) {
        // Retract the hook by moving start point towards endpoint
        // Stop after a certain length
        // set to swing once length reached
        guard let hookSystem = target.system(ofType: GrappleHookSystem.self),
              let positionSystem = target.system(ofType: PositionSystem.self),
              let hookOwnerId = hookSystem.getHookOwner(of: entityId) else {
            return
        }

        guard let lengthRemaining = hookSystem.lengthLeftToRetract(of: entityId),
              lengthRemaining > 0 else {
            hookSystem.setHookState(of: entityId, to: .swinging)
            return
        }

        hookSystem.retractHook(of: entityId)

        guard let startPointOfHook = hookSystem.getStartPoint(of: entityId) else {
            return
        }

        positionSystem.move(entityId: hookOwnerId, to: startPointOfHook)
    }
}
