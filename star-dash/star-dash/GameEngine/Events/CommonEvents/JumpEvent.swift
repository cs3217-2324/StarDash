//
//  JumpEvent.swift
//  star-dash
//
//  Created by Jason Qiu on 16/3/24.
//

import Foundation

class JumpEvent: Event {
    let entityId: EntityId
    let jumpImpulse: CGVector

    init(on entityId: EntityId, by jumpImpulse: CGVector, timestamp: Date) {
        self.entityId = entityId
        self.jumpImpulse = jumpImpulse
        super.init(playerIdForEvent: entityId, timestamp: timestamp)
    }
    convenience init(on entityId: EntityId, by jumpImpulse: CGVector) {
        self.init(on: entityId, by: jumpImpulse, timestamp: Date.now)
    }

  
}
