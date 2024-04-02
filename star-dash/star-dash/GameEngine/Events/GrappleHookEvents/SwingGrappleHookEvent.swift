//
//  SwingGrappleHookEvent.swift
//  star-dash
//
//  Created by Ho Jun Hao on 28/3/24.
//

import Foundation

class SwingGrappleHookEvent: Event {
    let timestamp: Date
    let hookId: EntityId

    init(using hookId: EntityId) {
        self.timestamp = Date.now
        self.hookId = hookId
    }
}
