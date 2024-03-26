import SpriteKit

public class SDCameraObject: SDObject {
    let cameraNode: SKCameraNode
    let player: SKObject?

    override public init() {
        cameraNode = SKCameraNode()
        super.init(node: cameraNode)
    }

    init(player: SKObject) {
        self.player = player
        cameraNode = SKCameraNode()
        super.init(node: cameraNode)
    }

    update() {
        self.position = player.position
    }
}
