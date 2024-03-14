import SpriteKit

public class GameScene: SKScene, SDScene {

    var sceneDelegate: SDSceneDelegate?

    private var lastUpdateTime: TimeInterval?

    override func update(_ currentTime: TimeInterval) {
        guard let lastUpdateTime = lastUpdateTime else {
            lastUpdateTime = currentTime
            return
        }

        let deltaTime = currentTime - lastUpdateTime
        lastUpdateTime = currentTime

        sceneDelegate?.update(self, deltaTime: deltaTime)
    }

    public func addObject(_ object: SDObject) {
        addChild(object.node)
    }
}
