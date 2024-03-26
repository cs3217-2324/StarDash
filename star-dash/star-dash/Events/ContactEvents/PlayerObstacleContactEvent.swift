//
//  PlayerObstacleContactEvent.swift
//  star-dash
//
//  Created by Lau Rui han on 26/3/24.
//

import Foundation
class PlayerObstacleContactEvent: Event {
    let timestamp: Date
    let entityId: EntityId
    let obstacleId: EntityId

    init(from playerEntityId: EntityId, on obstacleEntityId: EntityId) {
        self.timestamp = Date.now
        self.entityId = playerEntityId
        self.obstacleId = obstacleEntityId
    }
}
