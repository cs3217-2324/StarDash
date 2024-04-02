//
//  GrappleHookObstacleContactEvent.swift
//  star-dash
//
//  Created by Ho Jun Hao on 29/3/24.
//

import Foundation

class GrappleHookObstacleContactEvent: Event {
    let timestamp: Date
    let grappleHookId: EntityId
    let obstacleId: EntityId

    init(betweenHook grappleHookId: EntityId, andObstacle obstacleId: EntityId) {
        self.timestamp = Date.now
        self.grappleHookId = grappleHookId
        self.obstacleId = obstacleId
    }

    var playerIdForEvent: EntityId? {
        nil
    }
}
