import UIKit

extension UIView {
    convenience init(frame: CGRect, rotatedBy rotation: CGFloat) {
        self.init(frame: frame.applying(CGAffineTransform(rotationAngle: rotation)))
        self.transform = CGAffineTransform(rotationAngle: rotation)
        self.center = CGPoint(x: frame.midX, y: frame.midY)
    }
}
