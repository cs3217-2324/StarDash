import Foundation

class PowerUpBoxPlayerEvent: Event {
    let entityId: EntityId
    let powerUpBoxId: EntityId

    init(from playerEntityId: EntityId, pickedUp powerUpBoxId: EntityId, timestamp: Date) {
        self.entityId = playerEntityId
        self.powerUpBoxId = powerUpBoxId
        super.init(playerIdForEvent: playerEntityId, timestamp: timestamp)
    }

    convenience init(from playerEntityId: EntityId, pickedUp powerUpBoxId: EntityId) {
        self.init(from: playerEntityId, pickedUp: powerUpBoxId, timestamp: Date.now)
    }
}
