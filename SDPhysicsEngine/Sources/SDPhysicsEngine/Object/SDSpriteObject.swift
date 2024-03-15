import SpriteKit

public class SDSpriteObject: SDObject {
    let spriteNode: SKSpriteNode

    public var activeTexture: String?
    
    public init(imageNamed: String) {
        self.spriteNode = SKSpriteNode(imageNamed: imageNamed)
        super.init(node: spriteNode)
    }
    
    public var size: CGSize {
        get { spriteNode.size }
        set { spriteNode.size = newValue }
    }

    public func runTexture(named: String) {
        let texture = loadTexture(named: named)
        spriteNode.run(SKAction.repeatForever(
            SKAction.animate(with: texture, timePerFrame: TimeInterval(0.1), resize: false, restore: true)
        ))

        activeTexture = named
    }

    private func loadTexture(named: String) -> [SKTexture] {
        let textureAtlas = SKTextureAtlas(named: named)
        var frames = [SKTexture]()
        for idx in 0..<textureAtlas.textureNames.count {
            frames.append(textureAtlas.textureNamed(textureAtlas.textureNames[idx]))
        }
        return frames
    }
}
