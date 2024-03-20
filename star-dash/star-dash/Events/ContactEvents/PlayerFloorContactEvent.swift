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

    func execute(on target: EventModifiable) {
        guard let positionComponent = target.component(ofType: PositionComponent.self, ofEntity: entityId),
              let playerComponent = target.component(ofType: PlayerComponent.self, ofEntity: entityId),
              positionComponent.position.y > contactPoint.y else {
            return
        }

        playerComponent.isJumping = false
    }
}
