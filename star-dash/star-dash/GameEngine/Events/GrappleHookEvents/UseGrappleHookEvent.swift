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
    let position: CGPoint

    init(from playerId: EntityId, at position: CGPoint) {
        self.timestamp = Date.now
        self.playerId = playerId
        self.position = position
    }
}
