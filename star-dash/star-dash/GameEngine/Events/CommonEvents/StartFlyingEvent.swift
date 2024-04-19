import Foundation

class StartFlyingEvent: Event {

    let entityId: EntityId

    init(on entityId: EntityId, timestamp: Date) {
        self.entityId = entityId
        super.init(playerIdForEvent: entityId, timestamp: timestamp)
    }

    convenience init(on entityId: EntityId) {
        self.init(on: entityId, timestamp: Date.now)
    }

}
