struct TextureSet {
    let run: String
    let runLeft: String
    let death: String

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
        run: "PlayerRedNoseRun",
        runLeft: "PlayerRedNoseRunLeft",
        death: "PlayerRedNoseDeath"
    )

    static let star = "Star"

    static let monster = "Monster"

    static let obstacle = "Obstacle"

    static let powerUpBox = "Tool"

    static let hook = "GrapplingHook"

    static let rope = "Rope"

    static let speedBoostPowerUp = "SpeedBoostPowerUp"

    static let homingMissile = "HomingMissile"
}
