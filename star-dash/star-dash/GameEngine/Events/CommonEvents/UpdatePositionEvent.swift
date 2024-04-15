//
//  UpdatePositionEvent.swift
//  star-dash
//
//  Created by Lau Rui han on 15/4/24.
//

import Foundation
class UpdatePositionEvent: Event {
    let entityId: EntityId
    let position: CGPoint
    let rotation: CGFloat
    init(on entityId: EntityId, position: CGPoint, rotation: CGFloat, timestamp: Date) {
        self.entityId = entityId
        self.position = position
        self.rotation = rotation
        super.init(timestamp: timestamp)
    }
    convenience init(on entityId: EntityId, position: CGPoint, rotation: CGFloat) {
        
        self.init(on: entityId, position: position, rotation: rotation, timestamp: Date.now)
    }
}
