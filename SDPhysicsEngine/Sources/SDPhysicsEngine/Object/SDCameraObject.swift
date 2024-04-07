import SpriteKit

public class SDCameraObject: SDObject {
    let cameraNode: SKCameraNode
    let player: SDObject?
    let bounds: CGRect

    override public init() {
        self.cameraNode = SKCameraNode()
        self.player = nil
        self.bounds = .zero
        super.init(node: cameraNode)
    }

    init(player: SDObject, screenSize: CGSize, sceneSize: CGSize) {
        self.cameraNode = SKCameraNode()
        self.player = player

        let boundsOrigin = CGPoint(x: screenSize.width / 2, y: screenSize.height / 2)
        let boundsSize = CGSize(width: sceneSize.width - screenSize.width, height: sceneSize.height - screenSize.height)
        self.bounds = CGRect(origin: boundsOrigin, size: boundsSize)

        super.init(node: cameraNode)
    }

    var zRotation: CGFloat {
        get { cameraNode.zRotation }
        set { cameraNode.zRotation = newValue }
    }

    func update() {
        guard let player = player else {
            return
        }
        var newPosition = player.position
        if player.position.x < bounds.minX {
            newPosition.x = bounds.minX
        }
        if player.position.x > bounds.maxX {
            newPosition.x = bounds.maxX
        }
        if player.position.y < bounds.minY {
            newPosition.y = bounds.minY
        }
        if player.position.y > bounds.maxY {
            newPosition.y = bounds.maxY
        }
        self.position = newPosition
    }
}
