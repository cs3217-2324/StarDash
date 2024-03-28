//
//  PlayerAttackMonsterEvent.swift
//  star-dash
//
//  Created by Jason Qiu on 17/3/24.
//

import Foundation

class PlayerAttackMonsterEvent: Event {
    let timestamp: Date
    let playerId: EntityId
    let monsterId: EntityId

    init(from playerId: EntityId, on monsterId: EntityId) {
        self.timestamp = Date.now
        self.playerId = playerId
        self.monsterId = monsterId
    }
}
