//
//  UseGrappleHookEvent.swift
//  star-dash
//
//  Created by Jason Qiu on 17/3/24.
//

import Foundation

class UseGrappleHookEvent: Event {
    let timestamp: Date
    let playerId: EntityId

    init(from playerId: EntityId) {
        self.timestamp = Date.now
        self.playerId = playerId
    }

    var playerIdForEvent: EntityId? {
        playerId
    }
}
