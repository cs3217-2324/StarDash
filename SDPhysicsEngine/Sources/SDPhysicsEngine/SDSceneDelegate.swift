import CoreGraphics

public protocol SDSceneDelegate: AnyObject {

    func update(_ scene: SDScene, deltaTime: Double)
    func contactOccurred(objectA: SDObject, objectB: SDObject, contactPoint: CGPoint)
    func setupCameras()
}
