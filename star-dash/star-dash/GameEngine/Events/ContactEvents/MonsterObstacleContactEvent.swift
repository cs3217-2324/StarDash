//
//  MonsterObstacleContactEvent.swift
//  star-dash
//
//  Created by Ho Jun Hao on 5/4/24.
//

import Foundation

class MonsterObstacleContactEvent: Event {
    let timestamp: Date
    let monsterId: EntityId
    let obstacleId: EntityId
    let contactPoint: CGPoint

    init(from monsterId: EntityId, on obstacleEntityId: EntityId, at contactPoint: CGPoint) {
        self.timestamp = Date.now
        self.monsterId = monsterId
        self.obstacleId = obstacleEntityId
        self.contactPoint = contactPoint
    }

    var playerIdForEvent: EntityId? {
        nil
    }
}
