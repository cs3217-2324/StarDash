//
//  PlayerObstacleContactEvent.swift
//  star-dash
//
//  Created by Lau Rui han on 26/3/24.
//

import Foundation

class PlayerObstacleContactEvent: Event {
    let timestamp: Date
    let playerId: EntityId
    let obstacleId: EntityId

    init(from playerId: EntityId, on obstacleEntityId: EntityId) {
        self.timestamp = Date.now
        self.playerId = playerId
        self.obstacleId = obstacleEntityId
    }

    var playerIdForEvent: EntityId? {
        playerId
    }
}
