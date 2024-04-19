//
//  MonsterMovementReversalEvent.swift
//  star-dash
//
//  Created by Ho Jun Hao on 5/4/24.
//

import Foundation

class MonsterMovementReversalEvent: Event {
    let monsterId: EntityId
    let isLeft: Bool

    init(on monsterId: EntityId, isLeft: Bool, timestamp: Date) {
        self.monsterId = monsterId
        self.isLeft = isLeft
        super.init(timestamp: timestamp)
    }

    convenience init(on monsterId: EntityId, isLeft: Bool) {
        self.init(on: monsterId, isLeft: isLeft, timestamp: Date.now)
    }
}
