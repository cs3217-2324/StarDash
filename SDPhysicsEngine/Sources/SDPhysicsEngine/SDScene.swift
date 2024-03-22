import CoreGraphics

public protocol SDScene {

    var size: CGSize { get }

    func addObject(_ object: SDObject)
    func addCameraObject(_ cameraObject: SDCameraObject)
    func setCameraObjectXPosition(to x: CGFloat)
}
