import SpriteKit

public class SDPhysicsBody {
    let body: SKPhysicsBody

    public init(rectangleOf size: CGSize) {
        body = SKPhysicsBody(rectangleOf: size)
        body.friction = 0
        body.restitution = 0
    }

    public init(circleOf radius: CGFloat) {
        body = SKPhysicsBody(circleOfRadius: radius)
    }

    public var mass: CGFloat {
        get { body.mass }
        set { body.mass = newValue }
    }

    public var velocity: CGVector {
        get { body.velocity }
        set { body.velocity = newValue }
    }

    public var force: CGVector {
//         get { body.force }
//         set { body.force = newValue }
        CGVector(dx: 0, dy: 0)
    }

    public var restitution: CGFloat {
        get { body.restitution }
        set { body.restitution = newValue }
    }

    public var affectedByGravity: Bool {
        get { body.affectedByGravity }
        set { body.affectedByGravity = newValue }
    }

    public var isDynamic: Bool {
        get { body.isDynamic }
        set { body.isDynamic = newValue }
    }

    public var linearDamping: CGFloat {
        get { body.linearDamping }
        set { body.linearDamping = newValue }
    }

    public var categoryBitMask: UInt32 {
        get { body.categoryBitMask }
        set { body.categoryBitMask = newValue }
    }

    public var contactTestMask: UInt32 {
        get { body.contactTestBitMask }
        set { body.contactTestBitMask = newValue }
    }

    public var collisionBitMask: UInt32 {
        get { body.collisionBitMask }
        set { body.collisionBitMask = newValue }
    }
}
