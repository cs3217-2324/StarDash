//
//  PlayerToolContactEvent.swift
//  star-dash
//
//  Created by Lau Rui han on 26/3/24.
//

import Foundation
class PlayerToolContactEvent: Event {
    let timestamp: Date
    let playerId: EntityId
    let toolId: EntityId

    init(from playerId: EntityId, on toolEntityId: EntityId) {
        self.timestamp = Date.now
        self.playerId = playerId
        self.toolId = toolEntityId
    }
}
