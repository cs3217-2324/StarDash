import CoreGraphics

class PlayerFloorContactEvent: Event {
    let timestamp: Date
    let playerEntityId: EntityId
    let contactPoint: CGPoint

    init(from playerEntityId: EntityId, at contactPoint: CGPoint) {
        self.timestamp = Date.now
        self.playerEntityId = playerEntityId
        self.contactPoint = contactPoint
    }

    func execute(on target: EventModifiable) {
        guard let positionComponent = target.component(ofType: PositionComponent.self, ofEntity: playerEntityId),
              let playerComponent = target.component(ofType: PlayerComponent.self, ofEntity: playerEntityId),
              positionComponent.y > contactPoint.y else {
            return
        }

        playerComponent.isJumping = false
    }
}
