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
        guard let toolSystem = target.system(ofType: ToolSystem.self),
              let positionSystem = target.system(ofType: PositionSystem.self),
              let toolOwnerId = toolSystem.getToolOwner(of: entityId) else {
            return
        }

        guard let angleRemaining = toolSystem.angleLeftToSwing(of: entityId),
              angleRemaining > 0 else {
            toolSystem.setToolState(of: entityId, to: .releasing)
            return
        }

        toolSystem.swing(using: entityId)

        guard let startPointOfTool = toolSystem.getStartPoint(of: entityId) else {
            return
        }

        positionSystem.move(entityId: toolOwnerId, to: startPointOfTool)
    }
}
