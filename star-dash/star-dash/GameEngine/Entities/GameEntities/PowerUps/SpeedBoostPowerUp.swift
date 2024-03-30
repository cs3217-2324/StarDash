import Foundation

class SpeedBoostPowerUp: Entity {
    let id: EntityId
    private let playerEntityId: EntityId

    init(id: EntityId, playerEntityId: EntityId) {
        self.id = id
        self.playerEntityId = playerEntityId
    }

    convenience init(playerEntityId: EntityId) {
        self.init(id: UUID(), playerEntityId: playerEntityId)
    }

    func setUpAndAdd(to: EntityManager) {
        let speedBoostComponent = SpeedBoostComponent(
            entityId: self.playerEntityId,
            duration: 100000,
            multiplier: 2.5
        )
        to.add(entity: self)
        to.add(component: speedBoostComponent)
    }
}
