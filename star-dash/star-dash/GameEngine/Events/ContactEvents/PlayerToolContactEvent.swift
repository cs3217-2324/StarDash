//
//  PlayerToolContactEvent.swift
//  star-dash
//
//  Created by Lau Rui han on 26/3/24.
//

import Foundation
class PlayerToolContactEvent: Event {
    let playerId: EntityId
    let toolId: EntityId

    init(from playerId: EntityId, on toolEntityId: EntityId, timestamp: Date) {
        self.playerId = playerId
        self.toolId = toolEntityId
        super.init(playerIdForEvent: playerId, timestamp: timestamp)
    }

    convenience init(from playerId: EntityId, on toolEntityId: EntityId ) {
        self.init(from: playerId, on: toolEntityId)
    }

}
