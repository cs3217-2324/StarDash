import CoreGraphics

public protocol SDScene {

    var size: CGSize { get }

    func addObject(_ object: SDObject)
    func removeObject(_ object: SDObject)
}
