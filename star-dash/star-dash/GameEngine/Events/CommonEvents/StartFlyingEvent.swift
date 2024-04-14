import Foundation

class StartFlyingEvent: Event {
    let timestamp: Date
    let entityId: EntityId

    init(on entityId: EntityId) {
        self.timestamp = Date.now
        self.entityId = entityId
    }

    var playerIdForEvent: EntityId? {
        entityId
    }
}
