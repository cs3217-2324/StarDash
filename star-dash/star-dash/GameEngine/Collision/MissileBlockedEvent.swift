import Foundation

class MissileBlockedEvent: Event {
    let timestamp: Date
    let missileId: EntityId

    init(missile missileId: EntityId) {
        self.timestamp = Date.now
        self.missileId = missileId
    }
}
