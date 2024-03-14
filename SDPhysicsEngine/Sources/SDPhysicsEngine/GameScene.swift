import SpriteKit

public class GameScene: SKScene, SDScene {

    public func addObject(_ object: SDObject) {
        addChild(object.node)
    }
}
