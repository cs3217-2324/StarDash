import Foundation
import CoreGraphics

class PlayerFloorContactEvent: Event {
    let timestamp: Date
    let playerId: EntityId
    let contactPoint: CGPoint

    init(from playerId: EntityId, at contactPoint: CGPoint) {
        self.timestamp = Date.now
        self.playerId = playerId
        self.contactPoint = contactPoint
    }
}
