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
        // Delete hook entity
        guard let hookSystem = target.system(ofType: GrappleHookSystem.self),
              let playerReleaseImpulse = hookSystem.getPlayerReleaseImpulse(of: entityId),
              let playerOwnerId = hookSystem.getHookOwner(of: entityId),
              let physicsSystem = target.system(ofType: PhysicsSystem.self) else {
            return
        }

        physicsSystem.applyImpulse(to: playerOwnerId, impulse: playerReleaseImpulse)
        target.remove(entity: entityId)
    }
}
