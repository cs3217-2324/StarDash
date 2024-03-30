class PowerUpFactory {

    static func createPowerUp(triggeredBy playerId: EntityId, type: String, to entityManager: EntityManagerInterface) {
        let powerUps: [String: (EntityId, EntityManagerInterface) -> ()] = [
            "SpeedBoostPowerUp": createSpeedBoostPowerUp
        ]

        guard let createMethod = powerUps[type] else {
            return
        }

        createMethod(playerId, entityManager)
    }

    private static func createSpeedBoostPowerUp(triggeredBy playerId: EntityId, to entityManager: EntityManagerInterface) {
        EntityFactory.createAndAddSpeedBoostPowerUp(to: entityManager,
                                                    entityId: playerId,
                                                    duration: 1_000,
                                                    multiplier: 2.5)
    }
}
