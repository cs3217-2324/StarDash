//
//  MonsterWallContactEvent.swift
//  star-dash
//
//  Created by Ho Jun Hao on 13/4/24.
//

import Foundation

class MonsterWallContactEvent: Event {
    let timestamp: Date
    let monsterId: EntityId
    let wallId: EntityId
    let contactPoint: CGPoint

    init(from monsterId: EntityId, on wallId: EntityId, at contactPoint: CGPoint) {
        self.timestamp = Date.now
        self.monsterId = monsterId
        self.wallId = wallId
        self.contactPoint = contactPoint
    }

    var playerIdForEvent: EntityId? {
        nil
    }
}
