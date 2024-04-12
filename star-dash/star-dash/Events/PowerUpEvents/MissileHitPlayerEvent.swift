import Foundation

class MissileHitPlayerEvent: Event {
    let entityId: EntityId
    let missileId: EntityId

    init(from playerEntityId: EntityId, missile missileId: EntityId, timestamp: Date) {
        self.entityId = playerEntityId
        self.missileId = missileId
        super.init(playerIdForEvent: playerEntityId, timestamp: timestamp)
    }
    
    convenience init(from playerEntityId: EntityId, missile missileId: EntityId) {
        self.init(from: playerEntityId, missile: missileId, timestamp: Date.now)
    }

}
