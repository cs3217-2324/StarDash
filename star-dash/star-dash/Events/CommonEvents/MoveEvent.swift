//
//  MoveEvent.swift
//  star-dash
//
//  Created by Jason Qiu on 14/3/24.
//

import Foundation

class MoveEvent: Event {
    let timestamp: Date
    let entityId: EntityId

    let toLeft: Bool

    init(on entityId: EntityId, toLeft: Bool) {
        timestamp = Date.now
        self.entityId = entityId
        self.toLeft = toLeft
    }
}
