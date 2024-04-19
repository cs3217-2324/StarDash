import Foundation

class MissileBlockedEvent: Event {
    let missileId: EntityId

    init(missile missileId: EntityId, timestamp: Date) {
        self.missileId = missileId
        super.init(timestamp: timestamp)
    }

    convenience init(missile missileId: EntityId) {
        self.init(missile: missileId, timestamp: Date.now)
    }

}
