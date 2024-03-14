//
//  MoveEvent.swift
//  star-dash
//
//  Created by Jason Qiu on 14/3/24.
//

import Foundation

class MoveEvent: Event {
    var entityId: EntityId
    var timestamp: Date
    
    var displacement: CGVector
    
    init(entityId: EntityId, displacement: CGVector, timestamp: Date = Date.now) {
        self.entityId = entityId
        self.timestamp = timestamp
        self.displacement = displacement
    }
    
    func execute(on target: EventModifiable) { 
        // TODO: Use PositionSystem from target to modify entity of entityId
    }
}
