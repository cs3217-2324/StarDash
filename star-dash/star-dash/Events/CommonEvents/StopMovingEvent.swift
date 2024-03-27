import Foundation

class StopMovingEvent: Event {
    let timestamp: Date
    let entityId: EntityId

    init(on entityId: EntityId) {
        timestamp = Date.now
        self.entityId = entityId
    }

}
