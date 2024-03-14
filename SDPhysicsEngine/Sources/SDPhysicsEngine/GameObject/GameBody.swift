import SpriteKit

public class GameBody {
    let body: PhysicsBodyCore

    public init(rectangleOf size: CGSize, center: CGPoint) {
        body = PhysicsBodyCore(rectangleOf: size, center: center)
    }

    public init(circleOf radius: CGFloat, center: CGPoint) {
        body = PhysicsBodyCore(circleOfRadius: radius, center: center)
    }

    public var mass: CGFloat {
        get { body.mass }
        set { body.mass = newValue }
    }

    public var velocity: CGVector {
        get { body.velocity }
        set { body.velocity = newValue }
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
