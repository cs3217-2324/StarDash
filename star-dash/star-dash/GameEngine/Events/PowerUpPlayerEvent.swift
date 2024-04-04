import Foundation

class PowerUpPlayerEvent: Event {
    let timestamp: Date
    let entityId: EntityId
    let powerUpId: EntityId

    init(from playerEntityId: EntityId, pickedUp powerUpId: EntityId) {
        self.timestamp = Date.now
        self.entityId = playerEntityId
        self.powerUpId = powerUpId
    }

    var playerIdForEvent: EntityId? {
        entityId
    }
}
