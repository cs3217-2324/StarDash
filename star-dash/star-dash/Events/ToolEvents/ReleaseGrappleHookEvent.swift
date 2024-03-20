//
//  ReleaseGrappleHookEvent.swift
//  star-dash
//
//  Created by Ho Jun Hao on 18/3/24.
//

import Foundation

class ReleaseGrappleHookEvent: Event {
    let timestamp: Date
    let entityId: EntityId

    init(using hookEntityId: EntityId) {
        self.timestamp = Date.now
        entityId = hookEntityId
    }

    func execute(on target: EventModifiable) {
        // Give apply release impulse to player
        // Delete tool entity
        guard let toolSystem = target.system(ofType: ToolSystem.self),
              let playerReleaseImpulse = toolSystem.getPlayerReleaseImpulse(of: entityId),
              let playerOwnerId = toolSystem.getToolOwner(of: entityId),
              let physicsSystem = target.system(ofType: PhysicsSystem.self) else {
            return
        }

        physicsSystem.applyImpulse(to: playerOwnerId, impulse: playerReleaseImpulse)
        target.remove(entity: entityId)
    }
}
