import Foundation
import CoreGraphics

class PlayerFloorContactEvent: Event {
    let playerId: EntityId
    let contactPoint: CGPoint

    init(from playerId: EntityId, at contactPoint: CGPoint, timestamp: Date) {
        self.playerId = playerId
        self.contactPoint = contactPoint
        super.init(playerIdForEvent: playerId, timestamp: timestamp)
    }

    convenience init(from playerId: EntityId, at contactPoint: CGPoint) {
        self.init(from: playerId, at: contactPoint, timestamp: Date.now)
    }

}
