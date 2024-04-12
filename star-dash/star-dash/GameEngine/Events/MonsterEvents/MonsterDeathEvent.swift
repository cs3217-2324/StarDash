//
//  MonsterDeathEvent.swift
//  star-dash
//
//  Created by Jason Qiu on 16/3/24.
//

import Foundation

class MonsterDeathEvent: Event {
    let monsterId: EntityId

    init(on monsterId: EntityId, timestamp: Date) {
        self.monsterId = monsterId
        super.init(timestamp: timestamp)
    }

    convenience init(on monsterId: EntityId) {
        self.init(on: monsterId, timestamp: Date.now)
    }
}
