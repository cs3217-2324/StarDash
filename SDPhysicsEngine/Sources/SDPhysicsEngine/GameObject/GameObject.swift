import SpriteKit

public class GameObject {
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

    public var size: CGSize {
        get { node.size }
        set { node.size = newValue }
    }

    public var zPosition: CGFloat {
        get { node.zPosition }
        set { node.zPosition = newValue }
    }

    public var position: CGFloat {
        get { node.zPosition }
        set { node.zPosition = newValue }
    }

    public var physicsBody: GameBody {
        get { node.physicsBody }
        set { node.physicsBody = newValue.body }
    }
}
