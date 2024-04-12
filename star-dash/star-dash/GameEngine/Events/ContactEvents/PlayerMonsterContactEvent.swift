//
//  PlayerMonsterContactEvent.swift
//  star-dash
//
//  Created by Jason Qiu on 16/3/24.
//

import Foundation

class PlayerMonsterContactEvent: Event {
    let playerId: EntityId
    let monsterId: EntityId

    init(from playerId: EntityId, on monsterId: EntityId, timestamp: Date) {
        self.playerId = playerId
        self.monsterId = monsterId
        super.init(playerIdForEvent: playerId, timestamp: timestamp)
    }
    convenience init(from playerId: EntityId, on monsterId: EntityId) {
        self.init(from: playerId, on: monsterId, timestamp: Date.now)
    }


}
