import SpriteKit

public class SDPhysicsBody {
    let body: SKPhysicsBody

    public init(rectangleOf size: CGSize) {
        body = SKPhysicsBody(rectangleOf: size)
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
        // get { body.force }
        // set { body.force = newValue }
        CGVector(dx: 0, dy: 0)
    }

    public var affectedByGravity: Bool {
        get { body.affectedByGravity }
        set { body.affectedByGravity = newValue }
    }

    public var isDynamic: Bool {
        get { body.isDynamic }
        set { body.isDynamic = newValue }
    }
}
