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
}
