struct TextureSet {
    let run: String

    func getValueFor(key: String) -> String? {
        let mirror = Mirror(reflecting: self)

        for (property, value) in mirror.children {
            guard let property = property,
                  property == key else {
                continue
            }

            return value as? String
        }

        return nil
    }
}

struct SpriteConstants {
    static let PlayerRedNose = "PlayerRedNose"
    static let PlayerRedNoseTexture = TextureSet(
        run: "PlayerRedNoseRun"
    )

    static let star = "Star"

    static let monster = "Monster"

    static let obstacle = "Obstacle"

    static let tool = "Tool"

    static let hook = "GrapplingHook"

    static let rope = "Rope"

    static let speedBoostPowerUp = "SpeedBoostPowerUp"

    static let homingMissle = "HomingMissile"
}
