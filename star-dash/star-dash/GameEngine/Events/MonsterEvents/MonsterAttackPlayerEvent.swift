//
//  MonsterAttackPlayerEvent.swift
//  star-dash
//
//  Created by Jason Qiu on 16/3/24.
//

import Foundation

class MonsterAttackPlayerEvent: Event {
    let playerId: EntityId
    let monsterId: EntityId

    init(from monsterId: EntityId, on playerId: EntityId, timestamp: Date) {
        self.playerId = playerId
        self.monsterId = monsterId
        super.init(playerIdForEvent: playerId, timestamp: timestamp)
    }
    convenience init(from monsterId: EntityId, on playerId: EntityId) {
        self.init(from: monsterId, on: playerId, timestamp: Date.now)
    }

}
