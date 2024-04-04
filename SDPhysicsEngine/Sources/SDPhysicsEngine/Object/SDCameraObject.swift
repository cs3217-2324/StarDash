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

        // TODO: Improve on camera position handling
        var newPosition = player.position
        if player.position.x < screenSize.width / 2 + 200 {
            newPosition.x = screenSize.width / 2 + 200
        }

        if player.position.x > sceneSize.width - screenSize.width / 2 - 200 {
            newPosition.x = sceneSize.width - screenSize.width / 2 - 200
        }
        if player.position.y < screenSize.height / 2 + 100 {
            newPosition.y = screenSize.height / 2 + 100
        }

        if player.position.y > sceneSize.height - screenSize.height / 2 - 100 {
            newPosition.y = sceneSize.height - screenSize.height / 2 - 100
        }
        self.position = newPosition
    }
}
