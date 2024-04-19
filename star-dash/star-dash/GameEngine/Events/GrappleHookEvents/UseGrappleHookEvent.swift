//
//  UseGrappleHookEvent.swift
//  star-dash
//
//  Created by Jason Qiu on 17/3/24.
//

import Foundation

class UseGrappleHookEvent: Event {
    let playerId: EntityId
    let isLeft: Bool

    init(from playerId: EntityId, isLeft: Bool, timestamp: Date) {
        self.playerId = playerId
        self.isLeft = isLeft
        super.init(playerIdForEvent: playerId, timestamp: timestamp)
    }

    convenience init(from playerId: EntityId, isLeft: Bool) {
        self.init(from: playerId, isLeft: isLeft, timestamp: Date.now)
    }
}
