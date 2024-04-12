//
//  DeathEvent.swift
//  star-dash
//
//  Created by Ho Jun Hao on 12/4/24.
//

import Foundation

class DeathEvent: Event {
    let timestamp: Date
    let entityId: EntityId

    init(on entityId: EntityId) {
        self.timestamp = Date.now
        self.entityId = entityId
    }

    var playerIdForEvent: EntityId? {
        nil
    }
}
