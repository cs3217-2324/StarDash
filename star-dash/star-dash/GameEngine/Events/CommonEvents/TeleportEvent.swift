import Foundation

class TeleportEvent: Event {
    let entityId: EntityId
    let destination: CGPoint

    init(on entityId: EntityId, to destination: CGPoint, timestamp: Date) {
        self.entityId = entityId
        self.destination = destination
        super.init(playerIdForEvent: entityId, timestamp: timestamp)
    }

    convenience init(on entityId: EntityId, to destination: CGPoint) {
        self.init(on: entityId, to: destination, timestamp: Date.now)
    }

}
