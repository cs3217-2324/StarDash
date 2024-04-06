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
    let isLeft: Bool

    init(from playerId: EntityId, isLeft: Bool) {
        self.timestamp = Date.now
        self.playerId = playerId
        self.isLeft = isLeft
    }

    var playerIdForEvent: EntityId? {
        playerId
    }
}
