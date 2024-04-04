import Foundation

class MissileHitPlayerEvent: Event {
    let timestamp: Date
    let entityId: EntityId
    let missileId: EntityId

    init(from playerEntityId: EntityId, missile missileId: EntityId) {
        self.timestamp = Date.now
        self.entityId = playerEntityId
        self.missileId = missileId
    }

    var playerIdForEvent: EntityId? {
        entityId
    }
}
