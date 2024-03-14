import SpriteKit

class GameSpriteObject: Node {

    public init(imageNamed: String) {
        super.init(SKSpriteNode(imageNamed: imageNamed))
    }
}