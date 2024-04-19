//
//  MoveEvent.swift
//  star-dash
//
//  Created by Jason Qiu on 14/3/24.
//

import Foundation

class MoveEvent: Event {
    let entityId: EntityId
    let toLeft: Bool

    init(on entityId: EntityId, toLeft: Bool, timestamp: Date) {
        self.entityId = entityId

        self.toLeft = toLeft
        super.init(playerIdForEvent: entityId, timestamp: timestamp)
    }
    convenience init(on entityId: EntityId, toLeft: Bool) {
        self.init(on: entityId, toLeft: toLeft, timestamp: Date.now)
    }

}
