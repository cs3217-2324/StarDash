//
//  ShootGrappleHookEvent.swift
//  star-dash
//
//  Created by Ho Jun Hao on 18/3/24.
//

import Foundation

class ShootGrappleHookEvent: Event {
    let timestamp: Date
    let entityId: EntityId

    init(using hookEntityId: EntityId) {
        self.timestamp = Date.now
        entityId = hookEntityId
    }

    func execute(on target: EventModifiable) {
        guard let toolSystem = target.system(ofType: ToolSystem.self) else {
            return
        }

        guard toolSystem.length(of: entityId) >= Tool.DEFAULT_MAX_LENGTH else {
            toolSystem.extendTool(of: entityId)
            return
        }

        toolSystem.setToolState(of: entityId, to: .releasing)
    }
}
