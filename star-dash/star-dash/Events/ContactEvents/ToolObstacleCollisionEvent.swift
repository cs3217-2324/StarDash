//
//  ToolObstacleCollisionEvent.swift
//  star-dash
//
//  Created by Ho Jun Hao on 20/3/24.
//

import Foundation

class ToolObstacleCollisionEvent: Event {
    var entityId: EntityId

    let timestamp: Date
    let obstacleEntityId: EntityId

    init(betweenTool toolEntityId: EntityId, andObstacle obstacleEntityId: EntityId) {
        self.timestamp = Date.now
        self.entityId = toolEntityId
        self.obstacleEntityId = obstacleEntityId
    }

    func execute(on target: EventModifiable) {
        // 2 things can happen here, either collide when shooting or collide when swinging
        // if collide when shooting and greater than set distance: retract
        // otherwise release
        guard let toolSystem = target.system(ofType: ToolSystem.self),
              let toolState = toolSystem.getToolState(of: entityId) else {
            return
        }

        if toolState == .shooting && toolSystem.length(of: entityId) >= ToolComponent.MIN_LENGTH {
            toolSystem.setToolState(of: entityId, to: .retracting)
        } else {
            toolSystem.setToolState(of: entityId, to: .releasing)
        }
    }
}
