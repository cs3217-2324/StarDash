import SpriteKit

public class GameScene: SKScene {

    public var sceneDelegate: SDSceneDelegate?

    private var lastUpdateTime: TimeInterval?

    private var objectMap: [SKNode: SDObject] = [:]

    private var cameraPlayerMap: [Int: SDCameraObject] = [:]

    private var numberOfPlayers: Int = 0

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    public init(size: CGSize, for numberOfPlayers: Int) {
        self.numberOfPlayers = numberOfPlayers
        super.init(size: size)
    }

    override public func sceneDidLoad() {
        super.sceneDidLoad()

        physicsWorld.contactDelegate = self
    }

    override public func update(_ currentTime: TimeInterval) {
        super.update(currentTime)

        guard let lastUpdateTime = lastUpdateTime else {
            lastUpdateTime = currentTime
            return
        }
        let deltaTime = currentTime - lastUpdateTime
        self.lastUpdateTime = currentTime

        sceneDelegate?.update(self, deltaTime: deltaTime)
    }

    public func useCamera(of playerIndex: Int, rotatedBy rotation: CGFloat) {
        guard let cameraObject = cameraPlayerMap[playerIndex] else {
            return
        }
        cameraObject.zRotation = rotation
        self.camera = cameraObject.cameraNode
    }

}

extension GameScene: SDScene {
    public func addPlayerObject(_ playerObject: SDObject, playerIndex: Int) {
        let playerScreenSize = scaledPlayerScreenSize(for: numberOfPlayers)
        let camera = SDCameraObject(player: playerObject, screenSize: playerScreenSize, sceneSize: self.size)
        cameraPlayerMap[playerIndex] = camera

        addObject(camera)
        addObject(playerObject)
    }

    public func addObject(_ object: SDObject) {
        guard objectMap[object.node] == nil else {
            return
        }

        objectMap[object.node] = object
        addChild(object.node)
    }

    public func removeObject(_ object: SDObject) {
        objectMap[object.node] = nil
        object.removeFromParent()
    }

    private func scaledPlayerScreenSize(for numberOfPlayers: Int) -> CGSize {
        let screenSize = UIScreen.main.bounds.size

        // Default to horizontal orientation
        let screenWidth = max(screenSize.width, screenSize.height)
        let screenHeight = min(screenSize.width, screenSize.height)

        // Scale screen size using aspectFill method
        let xScale = screenWidth / self.size.width
        let yScale = screenHeight / self.size.height
        let scale = max(xScale, yScale)
        let scaledScreenSize = screenSize.applying(CGAffineTransform(scaleX: 1 / scale, y: 1 / scale))

        switch numberOfPlayers {
        case 1:
            return scaledScreenSize
        case 2:
            return CGSize(width: scaledScreenSize.height, height: scaledScreenSize.width / 2)
        default:
            return scaledScreenSize
        }
    }
}

extension GameScene: SKPhysicsContactDelegate {
    public func didBegin(_ contact: SKPhysicsContact) {
        guard let skNodeA = contact.bodyA.node,
              let skNodeB = contact.bodyB.node else {
            return
        }

        guard let objectA = objectMap[skNodeA],
              let objectB = objectMap[skNodeB] else {
            fatalError("Unknown node in game scene")
        }

        sceneDelegate?.contactOccurred(
            objectA: objectA,
            objectB: objectB,
            contactPoint: contact.contactPoint
        )
    }
}
