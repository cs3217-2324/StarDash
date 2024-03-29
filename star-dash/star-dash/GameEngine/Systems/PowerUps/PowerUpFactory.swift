class PowerUpFactory {

    static func createPowerUp(triggeredBy playerId: EntityId, type: String) -> Entity? {
        let powerUps: [String: (EntityId) -> Entity] = [
            "SpeedBoostPowerUp": createSpeedBoostPowerUp
        ]

        guard let createMethod = powerUps[type] else {
            return nil
        }

        return createMethod(playerId)
    }

    static private func createSpeedBoostPowerUp(triggeredBy playerId: EntityId) -> Entity {
        SpeedBoostPowerUp(playerEntityId: playerId)
    }
}
