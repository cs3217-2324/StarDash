import Foundation

class MissileBlockedEvent: Event {
    let timestamp: Date
    let missleId: EntityId

    init(missle missleId: EntityId) {
        self.timestamp = Date.now
        self.missleId = missleId
    }
}
