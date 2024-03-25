import Foundation

class TeleportEvent: Event {
    let timestamp: Date
    let entityId: EntityId

    let destination: CGPoint

    init(on entityId: EntityId, to destination: CGPoint) {
        timestamp = Date.now
        self.entityId = entityId
        self.destination = destination
    }
}
