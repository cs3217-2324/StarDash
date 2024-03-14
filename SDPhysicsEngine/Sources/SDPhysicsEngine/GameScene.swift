import Spritekit

class GameScene: SKScene {

    func addGameObject(_ gameObject: GameObject) {
        addChild(gameObject.node)
    }
}
