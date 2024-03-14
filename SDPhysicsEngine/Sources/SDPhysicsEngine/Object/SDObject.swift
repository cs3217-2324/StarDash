import SpriteKit

public class SDObject {
    let node: SKNode

    public init() {
        node = SKNode()
    }

    init(node: SKNode) {
        self.node = node
    }

    public var position: CGPoint {
        get { node.position }
        set { node.position = newValue }
    }

    public var zPosition: CGFloat {
        get { node.zPosition }
        set { node.zPosition = newValue }
    }

    public var physicsBody: SDPhysicsBody? {
        willSet { node.physicsBody = newValue?.body }
    }
}
