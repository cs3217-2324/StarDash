import SpriteKit

public class SDCameraObject: SDObject {
    let cameraNode: SKCameraNode
    let player: SDObject?
    let screenSize: CGSize
    let sceneSize: CGSize
    override public init() {
        player = nil
        cameraNode = SKCameraNode()
        screenSize = .zero
        sceneSize = .zero
        super.init(node: cameraNode)
    }

    init(player: SDObject, screenSize: CGSize, sceneSize: CGSize) {
        self.player = player
        self.screenSize = screenSize
        self.sceneSize = sceneSize
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
        var scale: CGFloat = 1
        // Calculate the distance between the player and the screen edges
        if sceneSize.height > 1024 {
            scale = 1024 / sceneSize.height
        }
//        let distanceToLeftEdge = player.position.x
//        let distanceToRightEdge = sceneSize.width - player.position.x
//        let distanceToTopEdge = sceneSize.height - player.position.y
//        let distanceToBottomEdge = player.position.y
//        
//        // Calculate the scale factor based on the minimum distance to the screen edges
//        let scaleX = min(screenSize.width / (distanceToLeftEdge + distanceToRightEdge), 1.0)
//        let scaleY = min(screenSize.height / (distanceToTopEdge + distanceToBottomEdge), 1.0)
//        let scale = min(scaleX, scaleY)

        // Set the scale of the camera node
        cameraNode.setScale(scale)

        // Calculate the new camera position based on the player's position
        let newCameraPosition = player.position

        // Update the camera position
        cameraNode.position = newCameraPosition



    }
}
