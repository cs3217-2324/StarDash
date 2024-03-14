import SpriteKit

public class SDSpriteObject: SDObject {
    let spriteNode: SKSpriteNode
    
    public init(imageNamed: String) {
        self.spriteNode = SKSpriteNode(imageNamed: imageNamed)
        super.init(node: spriteNode)
    }
    
    public var size: CGSize {
        get { spriteNode.size }
        set { spriteNode.size = newValue }
    }
}
