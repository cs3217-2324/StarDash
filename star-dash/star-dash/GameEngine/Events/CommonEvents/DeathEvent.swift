//
//  DeathEvent.swift
//  star-dash
//
//  Created by Ho Jun Hao on 12/4/24.
//

import Foundation

class DeathEvent: Event {
    let entityId: EntityId

    init(on entityId: EntityId, timestamp: Date) {
        self.entityId = entityId
        super.init(timestamp: timestamp)
    }
    convenience init(on entityId: EntityId) {
        self.init(on: entityId, timestamp: Date.now)
    }

}
