import SpriteKit

public class SDCameraObject: SDObject {
    let cameraNode: SKCameraNode
    let player: SDObject?

    override public init() {
        self.cameraNode = SKCameraNode()
        self.player = nil
        super.init(node: cameraNode)
    }

    init(player: SDObject, screenSize: CGSize, sceneSize: CGSize) {
        self.cameraNode = SKCameraNode()
        self.player = player

        let scale = sceneSize.height > 1_200 ? 0.5 : 1
        self.cameraNode.setScale(scale)

        super.init(node: cameraNode)
        setConstraints(player: player, screenSize: screenSize, sceneSize: sceneSize, scale: scale)
    }

    var zRotation: CGFloat {
        get { cameraNode.zRotation }
        set { cameraNode.zRotation = newValue }
    }

    private func setConstraints(player: SDObject, screenSize: CGSize, sceneSize: CGSize, scale: CGFloat) {
        let zeroRange = SKRange(constantValue: 0.0)
        let playerLocationConstraint = SKConstraint.distance(zeroRange, to: player.node)

        let sceneRect = CGRect(origin: .zero, size: sceneSize)
        let scaledScreenSize = screenSize.applying(CGAffineTransform(scaleX: scale, y: scale))
        let insetSceneRect = sceneRect.insetBy(dx: scaledScreenSize.width / 2, dy: scaledScreenSize.height / 2)
        let xRange = SKRange(lowerLimit: insetSceneRect.minX, upperLimit: insetSceneRect.maxX)
        let yRange = SKRange(lowerLimit: insetSceneRect.minY, upperLimit: insetSceneRect.maxY)
        let sceneEdgeConstraint = SKConstraint.positionX(xRange, y: yRange)

        self.cameraNode.constraints = [playerLocationConstraint, sceneEdgeConstraint]
    }
}
