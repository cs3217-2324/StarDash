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

    func execute(on target: EventModifiable) {
        guard let playerPositionComponent = target.component(ofType: PositionComponent.self, ofEntity: entityId),
              let obstaclePositionComponent = target.component(ofType: PositionComponent.self, ofEntity: obstacleId),
              let playerComponent = target.component(ofType: PlayerComponent.self, ofEntity: entityId),
              playerPositionComponent.position.y > obstaclePositionComponent.position.y else {
            return
        }

        playerComponent.canJump = true
        playerComponent.canMove = true
    }
}
