//
//  ReleaseGrappleHookEvent.swift
//  star-dash
//
//  Created by Ho Jun Hao on 28/3/24.
//

import Foundation

class ReleaseGrappleHookEvent: Event {
    let hookId: EntityId

    init(using hookId: EntityId, timestamp: Date) {
        self.hookId = hookId
        super.init(timestamp: timestamp)
    }

    convenience init(using hookId: EntityId) {
        self.init(using: hookId, timestamp: Date.now)
    }
}
