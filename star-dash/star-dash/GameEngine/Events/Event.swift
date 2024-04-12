//
//  Event.swift
//  star-dash
//
//  Created by Jason Qiu on 13/3/24.
//

import Foundation

class Event: Comparable {
    var playerIdForEvent: EntityId?
    var timestamp: Date
    
    init(playerIdForEvent: EntityId? = nil, timestamp: Date) {
        self.playerIdForEvent = playerIdForEvent
        self.timestamp = timestamp
    }
    
    static func == (lhs: Event, rhs:  Event) -> Bool {
            return lhs.timestamp == rhs.timestamp
    }
    
    static func < (lhs:  Event, rhs:  Event) -> Bool {
        return lhs.timestamp < rhs.timestamp
    }
}
