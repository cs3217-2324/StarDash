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
    let contactPoint: CGPoint

    init(from playerId: EntityId, on obstacleEntityId: EntityId, at contactPoint: CGPoint) {
        self.timestamp = Date.now
        self.playerId = playerId
        self.obstacleId = obstacleEntityId
        self.contactPoint = contactPoint
    }

    var playerIdForEvent: EntityId? {
        playerId
    }
}
