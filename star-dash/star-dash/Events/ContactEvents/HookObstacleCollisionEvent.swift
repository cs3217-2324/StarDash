//
//  HookObstacleCollisionEvent.swift
//  star-dash
//
//  Created by Ho Jun Hao on 20/3/24.
//

import Foundation

class HookObstacleCollisionEvent: Event {
    var entityId: EntityId

    let timestamp: Date
    let obstacleEntityId: EntityId

    init(betweenHook hookEntityId: EntityId, andObstacle obstacleEntityId: EntityId) {
        self.timestamp = Date.now
        self.entityId = hookEntityId
        self.obstacleEntityId = obstacleEntityId
    }

    func execute(on target: EventModifiable) {
        // 2 things can happen here, either collide when shooting or collide when swinging
        // if collide when shooting and greater than set distance: retract
        // otherwise release
        guard let hookSystem = target.system(ofType: GrappleHookSystem.self),
              let hookState = hookSystem.getHookState(of: entityId) else {
            return
        }

        if hookState == .shooting && hookSystem.length(of: entityId) >= GrappleHookComponent.MIN_LENGTH {
            hookSystem.setHookState(of: entityId, to: .retracting)
        } else {
            hookSystem.setHookState(of: entityId, to: .releasing)
        }
    }
}
