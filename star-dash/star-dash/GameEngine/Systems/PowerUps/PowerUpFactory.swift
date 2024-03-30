class PowerUpFactory {

    static func createPowerUp(triggeredBy playerId: EntityId, type: String, to entityManager: EntityManager) {
        let powerUps: [String: (EntityId, EntityManager) -> Entity] = [
            "SpeedBoostPowerUp": createSpeedBoostPowerUp
        ]

        guard let createMethod = powerUps[type] else {
            return nil
        }

        return createMethod(playerId, entityManager)
    }

    private static func createSpeedBoostPowerUp(triggeredBy playerId: EntityId, to entityManager: EntityManager) -> Entity {
        EntityFactory.createAndAddSpeedBoostPowerUp(to: entityManager,
                                                    entityId: playerId,
                                                    duration: 1_000,
                                                    multiplier: 2.5)
    }
}
