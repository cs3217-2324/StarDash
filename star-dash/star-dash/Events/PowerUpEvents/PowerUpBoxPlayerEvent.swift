import Foundation

class PowerUpBoxPlayerEvent: Event {
    let timestamp: Date
    let entityId: EntityId
    let powerUpBoxId: EntityId

    init(from playerEntityId: EntityId, pickedUp powerUpBoxId: EntityId) {
        self.timestamp = Date.now
        self.entityId = playerEntityId
        self.powerUpBoxId = powerUpBoxId
    }
}
