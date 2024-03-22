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
        guard let hookSystem = target.system(ofType: GrappleHookSystem.self) else {
            return
        }

        guard hookSystem.length(of: entityId) >= GrappleHook.DEFAULT_MAX_LENGTH else {
            hookSystem.extendHook(of: entityId)
            return
        }

        hookSystem.setHookState(of: entityId, to: .releasing)
    }
}
