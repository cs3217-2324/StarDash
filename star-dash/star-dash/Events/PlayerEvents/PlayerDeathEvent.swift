//
//  PlayerDeathEvent.swift
//  star-dash
//
//  Created by Jason Qiu on 17/3/24.
//

import Foundation

class PlayerDeathEvent: Event {
    let timestamp: Date
    let playerId: EntityId

    init(on playerId: EntityId) {
        self.timestamp = Date.now
        self.playerId = playerId
    }
}
