import SpriteKit

public class SDCameraObject: SDObject {
    let cameraNode: SKCameraNode
    let player: SDObject?

    override public init() {
        player = nil
        cameraNode = SKCameraNode()
        super.init(node: cameraNode)
    }

    init(player: SDObject) {
        self.player = player
        cameraNode = SKCameraNode()
        super.init(node: cameraNode)
    }

    var zRotation: CGFloat {
        get { cameraNode.zRotation }
        set { cameraNode.zRotation = newValue }
    }

    func update() {
        guard let player = self.player else {
            return
        }
        self.position = player.position
    }
}
