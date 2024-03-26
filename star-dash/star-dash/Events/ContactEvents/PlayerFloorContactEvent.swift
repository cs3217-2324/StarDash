import Foundation
import CoreGraphics

class PlayerFloorContactEvent: Event {
    let timestamp: Date
    let entityId: EntityId
    let contactPoint: CGPoint

    init(from playerEntityId: EntityId, at contactPoint: CGPoint) {
        self.timestamp = Date.now
        self.entityId = playerEntityId
        self.contactPoint = contactPoint
    }
}
