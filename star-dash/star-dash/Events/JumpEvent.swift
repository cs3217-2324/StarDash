//
//  JumpEvent.swift
//  star-dash
//
//  Created by Jason Qiu on 16/3/24.
//

import Foundation

class JumpEvent: Event {
    let entityId: EntityId
    let timestamp: Date

    let jumpImpulse: CGVector

    init(on entityId: EntityId, jumpImpulse: CGVector, timestamp: Date = Date.now) {
        self.entityId = entityId
        self.timestamp = timestamp
        self.jumpImpulse = jumpImpulse
    }

    func execute(on target: EventModifiable) {
        guard let physicsSystem = target.system(ofType: PhysicsSystem.self) else {
            return
        }
        guard !physicsSystem.isJumping(entityId) else {
            return
        }
        physicsSystem.applyImpulse(to: entityId, impulse: jumpImpulse)
    }
}
