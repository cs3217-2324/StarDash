struct TextureSet {
    let run: String
    let runLeft: String
    let death: String
    let fly: String

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

struct ImageSet: Hashable {
    let faceRight: String
    let faceLeft: String

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
    static let playerRedNose = ImageSet(
        faceRight: "PlayerRedNose",
        faceLeft: "PlayerRedNoseLeft"
    )
    static let playerRedNoseTexture = TextureSet(
        run: "PlayerRedNoseRun",
        runLeft: "PlayerRedNoseRunLeft",
        death: "PlayerRedNoseDeath",
        fly: "Plane"
    )
    static let playerRedNoseIcon = "PlayerRedNoseIcon"

    static let playerAdventurer = ImageSet(
        faceRight: "PlayerAdventurer",
        faceLeft: "PlayerAdventurerLeft"
    )
    static let playerAdventurerTexture = TextureSet(
        run: "PlayerAdventurerRun",
        runLeft: "PlayerAdventurerRunLeft",
        death: "PlayerAdventurerDeath"
    )
    static let playerAdventurerIcon = "PlayerAdventurerIcon"

    static let playerJack = ImageSet(
        faceRight: "PlayerJack",
        faceLeft: "PlayerJackLeft"
    )
    static let playerJackTexture = TextureSet(
        run: "PlayerJackRun",
        runLeft: "PlayerJackRunLeft",
        death: "PlayerJackDeath"
    )
    static let playerJackIcon = "PlayerJackIcon"

    static let playerNinja = ImageSet(
        faceRight: "PlayerNinja",
        faceLeft: "PlayerNinjaLeft"
    )
    static let playerNinjaTexture = TextureSet(
        run: "PlayerNinjaRun",
        runLeft: "PlayerNinjaRunLeft",
        death: "PlayerNinjaDeath"
    )
    static let playerNinjaIcon = "PlayerNinjaIcon"

    static let playerImageIconMap = [
        playerRedNose: playerRedNoseIcon,
        playerAdventurer: playerAdventurerIcon,
        playerJack: playerJackIcon,
        playerNinja: playerNinjaIcon
    ]

    static let star = ImageSet(
        faceRight: "Star",
        faceLeft: "Star"
    )

    static let monster = ImageSet(
        faceRight: "Monster",
        faceLeft: "Monster"
    )
    static let monsterTexture = TextureSet(
        run: "MonsterWalk",
        runLeft: "MonsterWalkLeft",
        death: "MonsterDeath",
        fly: "Plane"
    )

    static let obstacle = ImageSet(
        faceRight: "Obstacle",
        faceLeft: "Obstacle"
    )
    static let powerUpBox = ImageSet(
        faceRight: "Tool",
        faceLeft: "Tool"
    )

    static let hook = ImageSet(
        faceRight: "GrapplingHook",
        faceLeft: "GrapplingHook"
    )

    static let rope = ImageSet(
        faceRight: "Rope",
        faceLeft: "Rope"
    )

    static let speedBoostPowerUp = ImageSet(
        faceRight: "SpeedBoostPowerUp",
        faceLeft: "SpeedBoostPowerUp"
    )

    static let homingMissile = ImageSet(
        faceRight: "HomingMissile",
        faceLeft: "HomingMissile"
    )

    static let flag = ImageSet(
        faceRight: "Flag",
        faceLeft: "Flag"
    )
}
