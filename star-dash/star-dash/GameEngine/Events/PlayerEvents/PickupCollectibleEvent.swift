//
//  PickupCollectibleEvent.swift
//  star-dash
//
//  Created by Jason Qiu on 16/3/24.
//

import Foundation

class PickupCollectibleEvent: Event {
    let timestamp: Date
    let playerId: EntityId
    let collectibleEntityId: EntityId

    init(by playerId: EntityId, collectibleEntityId: EntityId) {
        self.timestamp = Date.now
        self.playerId = playerId
        self.collectibleEntityId = collectibleEntityId
    }
}
