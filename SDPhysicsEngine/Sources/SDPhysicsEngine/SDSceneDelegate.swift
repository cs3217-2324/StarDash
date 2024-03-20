public protocol SDSceneDelegate: AnyObject {

    func update(_ scene: SDScene, deltaTime: Double)
    func contactOccured(objectA: SDObject, objectB: SDObject, contactPoint: CGPoint)
}
