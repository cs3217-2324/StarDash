//
//  GrappleHookObstacleContactEvent.swift
//  star-dash
//
//  Created by Ho Jun Hao on 29/3/24.
//

import Foundation

class GrappleHookObstacleContactEvent: Event {
    let grappleHookId: EntityId
    let obstacleId: EntityId

    init(betweenHook grappleHookId: EntityId, andObstacle obstacleId: EntityId, timestamp: Date) {
        self.grappleHookId = grappleHookId
        self.obstacleId = obstacleId
        super.init(timestamp: timestamp)
    }

    convenience init(betweenHook grappleHookId: EntityId, andObstacle obstacleId: EntityId) {
        self.init(betweenHook: grappleHookId, andObstacle: obstacleId, timestamp: Date.now)
    }

}
