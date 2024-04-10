import CoreGraphics

class PowerUpFactory {

    static func createPowerUp(triggeredBy playerId: EntityId,
                              type: String,
                              to entityManager: EntityManager,
                              with eventManager: EventModifiable?) {
        let powerUps: [String: (EntityId, EntityManager, EventModifiable?) -> Void] = [
            "SpeedBoostPowerUp": createSpeedBoostPowerUp,
            "HomingMissilePowerUp": createHomingMissilePowerUp,
            "FlyingPowerUp": startEntityFlying
        ]

        guard let createMethod = powerUps[type] else {
            return
        }

        createMethod(playerId, entityManager, eventManager)
    }

    private static func createSpeedBoostPowerUp(triggeredBy playerId: EntityId,
                                                to entityManager: EntityManager,
                                                with eventManager: EventModifiable?) {
        EntityFactory.createAndAddSpeedBoostPowerUp(to: entityManager,
                                                    entityId: playerId,
                                                    duration: 15,
                                                    multiplier: 1.5)
    }

    private static func createHomingMissilePowerUp(triggeredBy playerId: EntityId,
                                                   to entityManager: EntityManager,
                                                   with eventManager: EventModifiable?) {
        guard let positionComponent = entityManager.component(ofType: PositionComponent.self, of: playerId) else {
            return
        }

        let missilePosition = CGPoint(x: positionComponent.position.x + 100, y: positionComponent.position.y)

        EntityFactory.createAndAddHomingMissilePowerUp(to: entityManager,
                                                       position: missilePosition,
                                                       impulse: CGVector(dx: 4_000, dy: 0))
    }

    private static func startEntityFlying(triggeredBy playerId: EntityId,
                                          to entityManager: EntityManager,
                                          with eventManager: EventModifiable?) {
        eventManager.add(event: StartFlyingEvent(on: playerId))
    }
}
