import CoreGraphics

public protocol SDScene {

    var size: CGSize { get }

    func addPlayerObject(_ playerObject: SDObject, playerIndex: Int)
    func addObject(_ object: SDObject)
    func removeObject(_ object: SDObject)
}
