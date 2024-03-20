//
//  JumpEvent.swift
//  star-dash
//
//  Created by Jason Qiu on 16/3/24.
//

import Foundation

class JumpEvent: Event {
    let timestamp: Date
    let entityId: EntityId

    let jumpImpulse: CGVector

    init(on entityId: EntityId, by jumpImpulse: CGVector) {
        timestamp = Date.now
        self.entityId = entityId
        self.jumpImpulse = jumpImpulse
    }

    func execute(on target: EventModifiable) {
        guard let physicsSystem = target.system(ofType: PhysicsSystem.self) else {
            return
        }

        guard let playerComponent = target.component(ofType: PlayerComponent.self, ofEntity: entityId),
              playerComponent.canJump else {
            return
        }
        playerComponent.canJump = false
        playerComponent.canMove = false

        physicsSystem.applyImpulse(to: entityId, impulse: jumpImpulse)
    }
}
