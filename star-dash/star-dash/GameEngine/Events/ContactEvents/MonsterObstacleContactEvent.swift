//
//  MonsterObstacleContactEvent.swift
//  star-dash
//
//  Created by Ho Jun Hao on 5/4/24.
//

import Foundation

class MonsterObstacleContactEvent: Event {
    let monsterId: EntityId
    let obstacleId: EntityId
    let contactPoint: CGPoint

    init(from monsterId: EntityId, on obstacleEntityId: EntityId, at contactPoint: CGPoint, timestamp: Date) {
        self.monsterId = monsterId
        self.obstacleId = obstacleEntityId
        self.contactPoint = contactPoint
        super.init(timestamp: timestamp)
    }
    convenience init(from monsterId: EntityId, on obstacleEntityId: EntityId, at contactPoint: CGPoint) {
        self.init(from: monsterId, on: obstacleEntityId, at: contactPoint, timestamp: Date.now)
    }


}
