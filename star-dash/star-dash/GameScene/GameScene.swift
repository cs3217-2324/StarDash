import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var ball: SKShapeNode?
    var platform: SKShapeNode?
    
    var camBall: SKCameraNode?
    var camPlatform: SKCameraNode?
    
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        
        guard let ball = self.ball,
              let platform = self.platform else {
            return
        }
        
        camBall?.position = ball.position
        camPlatform?.position = platform.position
        return
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        return
    }
    
    func setupGame() {
        
        self.physicsWorld.gravity = CGVector(dx: physicsWorld.gravity.dx, dy: physicsWorld.gravity.dy * 0.3)
        
        let ball = SKShapeNode(circleOfRadius: 10)
        ball.physicsBody = SKPhysicsBody(circleOfRadius: 10)
        ball.position = CGPoint(x: size.width / 2, y: size.height / 2 + 200)
        //ball.fillColor = .blue
        self.ball = ball
        
        let platform = SKShapeNode(rectOf: CGSize(width: 200, height: 50))
        platform.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 200, height: 50))
        platform.physicsBody?.isDynamic = false
        platform.position = CGPoint(x: size.width / 2, y: size.height / 2 - 200)
        // platform.fillColor = .black
        self.platform = platform
        
        addChild(ball)
        addChild(platform)
        
        camBall = SKCameraNode()
        camBall?.position = ball.position
        camBall?.yScale = -1
        
        camPlatform = SKCameraNode()
        camPlatform?.position = platform.position
    }
}
