import SpriteKit

public class SDSpriteObject: SDObject {
    let spriteNode: SKSpriteNode
    let originalImage: String

    static let textureActionKey = "animation"
    public var activeTexture: String?

    public init(imageNamed: String) {
        self.spriteNode = SKSpriteNode(imageNamed: imageNamed)
        self.originalImage = imageNamed
        super.init(node: spriteNode)
    }

    public var size: CGSize {
        get { spriteNode.size }
        set { spriteNode.size = newValue }
    }

    public var texture: String? {
        willSet {
            guard let texture = newValue else {
                return
            }
            spriteNode.texture = SKTexture(imageNamed: texture)
        }
    }

    /// Runs an animation with the given name of a texture atlas.
    /// Params:
    /// - named: Name of texture atlas
    /// - repetitive: True if the texture should be repeated indefinitely
    /// - duration: If nil, original sprite will render immediately after animation ends.
    ///          Else, it only renders after given duration.
    public func runTexture(named: String, repetitive: Bool, duration: Double?) {
        let timePerFrame: Double = 0.1
        let texture = loadTexture(named: named)
        var animation = SKAction.animate(with: texture,
                                         timePerFrame: TimeInterval(timePerFrame),
                                         resize: false,
                                         restore: duration == nil)

        if repetitive {
            animation = SKAction.repeatForever(animation)
        }

        spriteNode.run(animation, withKey: SDSpriteObject.textureActionKey)

        if let duration = duration {
            spriteNode.run(SKAction.wait(forDuration: duration)) {
                self.spriteNode.texture = SKTexture(imageNamed: self.originalImage)
            }
        }

        activeTexture = named
    }

    public func cancelTexture() {
        spriteNode.removeAction(forKey: SDSpriteObject.textureActionKey)
        activeTexture = nil
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
