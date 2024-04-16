//
//  MonsterWallContactEvent.swift
//  star-dash
//
//  Created by Ho Jun Hao on 13/4/24.
//

import Foundation

class MonsterWallContactEvent: Event {
    let monsterId: EntityId
    let wallId: EntityId
    let contactPoint: CGPoint

    init(from monsterId: EntityId, on wallId: EntityId, at contactPoint: CGPoint, timestamp: Date) {
        self.monsterId = monsterId
        self.wallId = wallId
        self.contactPoint = contactPoint
        super.init(timestamp: timestamp)
    }

    convenience init(from monsterId: EntityId, on wallId: EntityId, at contactPoint: CGPoint) {
        self.init(from: monsterId, on: wallId, at: contactPoint, timestamp: Date.now)
    }

}
