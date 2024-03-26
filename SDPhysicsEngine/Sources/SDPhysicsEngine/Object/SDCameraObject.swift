import SpriteKit

public class SDCameraObject: SDObject {
    let cameraNode: SKCameraNode
    let player: SKNode?

    override public init() {
        player = nil
        cameraNode = SKCameraNode()
        super.init(node: cameraNode)
    }

    init(player: SKNode) {
        self.player = player
        cameraNode = SKCameraNode()
        super.init(node: cameraNode)
    }

    func update() {
        guard let player = self.player else {
            return
        }
        self.position = player.position
    }
}
