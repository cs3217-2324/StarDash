//
//  UseGrappleHookEvent.swift
//  star-dash
//
//  Created by Jason Qiu on 17/3/24.
//

import Foundation

class UseGrappleHookEvent: Event {
    let timestamp: Date
    let entityId: EntityId

    init(from playerEntityId: EntityId) {
        self.timestamp = Date.now
        entityId = playerEntityId
    }

    func execute(on target: EventModifiable) {
        guard let hookSystem = target.system(ofType: GrappleHookSystem.self),
              let positionSystem = target.system(ofType: PositionSystem.self) else {
            return
        }

        guard let playerPosition = positionSystem.getPosition(of: entityId) else {
            return
        }

        hookSystem.activateHook(at: playerPosition, ownedBy: entityId)
    }
}
