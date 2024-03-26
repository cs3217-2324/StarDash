//
//  JumpEvent.swift
//  star-dash
//
//  Created by Jason Qiu on 16/3/24.
//

import Foundation

class JumpEvent: Event {
    let timestamp: Date
    let entityId: EntityId

    let jumpImpulse: CGVector

    init(on entityId: EntityId, by jumpImpulse: CGVector) {
        timestamp = Date.now
        self.entityId = entityId
        self.jumpImpulse = jumpImpulse
    }

}
