//
//  PickupCollectibleEvent.swift
//  star-dash
//
//  Created by Jason Qiu on 16/3/24.
//

import Foundation

class PickupCollectibleEvent: Event {
    let playerId: EntityId
    let collectibleEntityId: EntityId

    init(by playerId: EntityId, collectibleEntityId: EntityId, timestamp: Date) {
        self.playerId = playerId
        self.collectibleEntityId = collectibleEntityId
        super.init(playerIdForEvent: playerId, timestamp: timestamp)
    }

    convenience init(by playerId: EntityId, collectibleEntityId: EntityId) {
        self.init(by: playerId, collectibleEntityId: collectibleEntityId, timestamp: Date.now)
    }

}
