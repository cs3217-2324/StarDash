import SpriteKit

public class SDCameraObject: SDObject {
    let cameraNode: SKCameraNode
    let player: SDObject?

    override public init() {
        self.cameraNode = SKCameraNode()
        self.player = nil
        super.init(node: cameraNode)
    }

    init(player: SDObject) {
        self.cameraNode = SKCameraNode()
        self.player = player
        super.init(node: cameraNode)
    }

    var zRotation: CGFloat {
        get { cameraNode.zRotation }
        set { cameraNode.zRotation = newValue }
    }

    func setup(playerScreenSize: CGSize, sceneSize: CGSize) {
        let scale = sceneSize.height > 1_200 ? 0.5 : 1
        self.cameraNode.setScale(scale)

        var constraints = [SKConstraint]()

        if let player = player {
            let zeroRange = SKRange(constantValue: 0.0)
            let playerLocationConstraint = SKConstraint.distance(zeroRange, to: player.node)
            constraints.append(playerLocationConstraint)
        }

        let sceneRect = CGRect(origin: .zero, size: sceneSize)
        let scaledScreenSize = playerScreenSize.applying(CGAffineTransform(scaleX: scale, y: scale))
        let insetSceneRect = sceneRect.insetBy(dx: scaledScreenSize.width / 2, dy: scaledScreenSize.height / 2)
        let xRange = SKRange(lowerLimit: insetSceneRect.minX, upperLimit: insetSceneRect.maxX)
        let yRange = SKRange(lowerLimit: insetSceneRect.minY, upperLimit: insetSceneRect.maxY)
        let sceneEdgeConstraint = SKConstraint.positionX(xRange, y: yRange)
        constraints.append(sceneEdgeConstraint)

        self.cameraNode.constraints = constraints
    }
}
