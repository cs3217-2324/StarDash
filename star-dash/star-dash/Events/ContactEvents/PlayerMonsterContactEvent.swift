//
//  PlayerMonsterContactEvent.swift
//  star-dash
//
//  Created by Jason Qiu on 16/3/24.
//

import Foundation

class PlayerMonsterContactEvent: Event {
    var entityId: EntityId

    let timestamp: Date
    let monsterId: EntityId

    init(from playerId: EntityId, on monsterId: EntityId) {
        self.timestamp = Date.now
        self.entityId = playerId
        self.monsterId = monsterId
    }

    func execute(on target: EventModifiable) {
        guard let positionSystem = target.system(ofType: PositionSystem.self),
              let physicsSystem = target.system(ofType: PhysicsSystem.self) else {
            return
        }

        guard let playerPosition = positionSystem.getPosition(of: entityId),
              let monsterPosition = positionSystem.getPosition(of: monsterId) else {
            return
        }

        guard let playerSize = physicsSystem.getSize(of: entityId),
              let monsterSize = physicsSystem.getSize(of: monsterId) else {
            return
        }

        let isPlayerAbove = playerPosition.y - (playerSize.height / 2) >= monsterPosition.y + (monsterSize.height / 2)

        if isPlayerAbove {
            target.add(event: PlayerAttackMonsterEvent(on: monsterId))
        } else {
            target.add(event: MonsterAttackPlayerEvent(from: monsterId, on: entityId))
        }
    }
}
