//
//  RemoveEvent.swift
//  star-dash
//
//  Created by Jason Qiu on 16/3/24.
//

import Foundation

class RemoveEvent: Event {
    let timestamp: Date
    let entityId: EntityId

    init(on entityId: EntityId) {
        self.timestamp = Date.now
        self.entityId = entityId
    }
}
