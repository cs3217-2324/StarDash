import SpriteKit

public class SDObject {
    let node: SKNode
    
    var innerRotation: CGFloat = 0

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
    
    public var rotation: CGFloat {
        get { innerRotation }
        set {
            innerRotation = newValue
            node.run(SKAction.rotate(toAngle: newValue, duration: 1))
        }
    }

    public var physicsBody: SDPhysicsBody? {
        willSet { node.physicsBody = newValue?.body }
    }
}
