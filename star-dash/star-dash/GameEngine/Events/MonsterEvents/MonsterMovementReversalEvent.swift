//
//  MonsterMovementReversalEvent.swift
//  star-dash
//
//  Created by Ho Jun Hao on 5/4/24.
//

import Foundation

class MonsterMovementReversalEvent: Event {
    let timestamp: Date
    let monsterId: EntityId
    let isLeft: Bool

    init(on monsterId: EntityId, isLeft: Bool) {
        self.timestamp = Date.now
        self.monsterId = monsterId
        self.isLeft = isLeft
    }

    var playerIdForEvent: EntityId? {
        nil
    }
}
