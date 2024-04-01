class PowerUpFactory {

    static func createPowerUp(triggeredBy playerId: EntityId, type: String, to entityManager: EntityManagerInterface) {
        let powerUps: [String: (EntityId, EntityManagerInterface) -> Void] = [
            "SpeedBoostPowerUp": createSpeedBoostPowerUp,
            "HomingMisslePowerUp": createHomingMisslePowerUp
        ]

        guard let createMethod = powerUps[type] else {
            return
        }

        createMethod(playerId, entityManager)
    }

    private static func createSpeedBoostPowerUp(triggeredBy playerId: EntityId,
                                                to entityManager: EntityManagerInterface) {
        EntityFactory.createAndAddSpeedBoostPowerUp(to: entityManager,
                                                    entityId: playerId,
                                                    duration: 15,
                                                    multiplier: 2.5)
    }

    private static func createHomingMisslePowerUp(triggeredBy playerId: EntityId,
                                                to entityManager: EntityManagerInterface) {
        guard let positionComponent = entityManager.component(ofType: PositionComponent.self, of: playerId) else {
            return
        }

        EntityFactory.createAndAddHomingMissle(to: entityManager,
                                               position: positionComponent.position,
                                               impulse: CGVector(dx: 2_000, dy: 0))
    }
}
