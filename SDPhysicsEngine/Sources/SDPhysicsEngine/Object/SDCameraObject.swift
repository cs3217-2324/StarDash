import SpriteKit

public class SDCameraObject: SDObject {
    let cameraNode: SKCameraNode

    override public init() {
        cameraNode = SKCameraNode()
        super.init(node: cameraNode)
    }
}
