//
//  RemoveEvent.swift
//  star-dash
//
//  Created by Jason Qiu on 16/3/24.
//

import Foundation

class RemoveEvent: Event {
    let entityId: EntityId

    init(on entityId: EntityId, timestamp: Date) {
        self.entityId = entityId
        super.init(playerIdForEvent: nil, timestamp: timestamp)
    }
    convenience init(on entityId: EntityId) {
        self.init(on: entityId, timestamp: Date.now)
    }
}
