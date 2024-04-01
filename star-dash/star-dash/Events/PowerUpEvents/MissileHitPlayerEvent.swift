import Foundation

class MissileHitPlayerEvent: Event {
    let timestamp: Date
    let entityId: EntityId
    let missleId: EntityId

    init(from playerEntityId: EntityId, missle missleId: EntityId) {
        self.timestamp = Date.now
        self.entityId = playerEntityId
        self.missleId = missleId
    }
}
