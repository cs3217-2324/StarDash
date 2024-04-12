//
//  PlayerObstacleContactEvent.swift
//  star-dash
//
//  Created by Lau Rui han on 26/3/24.
//

import Foundation

class PlayerObstacleContactEvent: Event {
    let playerId: EntityId
    let obstacleId: EntityId
    let contactPoint: CGPoint

    init(from playerId: EntityId, on obstacleEntityId: EntityId, at contactPoint: CGPoint, timestamp: Date) {
        self.playerId = playerId
        self.obstacleId = obstacleEntityId
        self.contactPoint = contactPoint
        super.init(playerIdForEvent: playerId, timestamp: timestamp)
    }

    convenience init(from playerId: EntityId, on obstacleEntityId: EntityId, at contactPoint: CGPoint) {
        self.init(from: playerId, on: obstacleEntityId, at: contactPoint, timestamp: Date.now)
    }

}
