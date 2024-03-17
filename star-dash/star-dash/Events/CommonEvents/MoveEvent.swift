//
//  MoveEvent.swift
//  star-dash
//
//  Created by Jason Qiu on 14/3/24.
//

import Foundation

class MoveEvent: Event {
    let timestamp: Date
    let entityId: EntityId

    let destination: CGPoint

    init(on entityId: EntityId, to destination: CGPoint) {
        timestamp = Date.now
        self.entityId = entityId
        self.destination = destination
    }

    func execute(on target: EventModifiable) {
        guard let positionSystem = target.system(ofType: PositionSystem.self) else {
            return
        }
        positionSystem.move(entityId: entityId, to: destination)
    }
}
