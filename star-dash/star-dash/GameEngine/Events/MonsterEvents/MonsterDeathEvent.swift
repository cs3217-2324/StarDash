//
//  MonsterDeathEvent.swift
//  star-dash
//
//  Created by Jason Qiu on 16/3/24.
//

import Foundation

class MonsterDeathEvent: Event {
    let timestamp: Date
    let monsterId: EntityId

    init(on monsterId: EntityId) {
        self.timestamp = Date.now
        self.monsterId = monsterId
    }

    var playerIdForEvent: EntityId? {
        nil
    }
}
