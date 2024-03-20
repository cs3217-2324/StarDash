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
        // Retract the tool by moving start point towards endpoint
        // Stop after a certain length
        // set to swing once length reached
        guard let toolSystem = target.system(ofType: ToolSystem.self),
              let positionSystem = target.system(ofType: PositionSystem.self),
              let toolOwnerId = toolSystem.getToolOwner(of: entityId) else {
            return
        }

        guard let lengthRemaining = toolSystem.lengthLeftToRetract(of: entityId),
              lengthRemaining > 0 else {
            toolSystem.setToolState(of: entityId, to: .swinging)
            return
        }

        toolSystem.retractTool(of: entityId)

        guard let startPointOfTool = toolSystem.getStartPoint(of: entityId) else {
            return
        }

        positionSystem.move(entityId: toolOwnerId, to: startPointOfTool)
    }
}
