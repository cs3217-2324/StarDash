import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {

    var ball: SKNode?
    var platform: SKNode?

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

        let background  = SKSpriteNode(imageNamed: "GameBackground")
        background.position = CGPoint(x: size.width / 2, y: size.height / 2)
        background.zPosition = -1
        addChild(background)

        let ball = SKSpriteNode(imageNamed: "PlayerRedNose")
        ball.size = CGSize(width: 100, height: 140)
        ball.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 60, height: 110))
        ball.position = CGPoint(x: size.width / 2, y: size.height / 2 + 200)
        self.ball = ball

        let textureAtlas = SKTextureAtlas(named: "PlayerRedNoseRun")
        var frames = [SKTexture]()
        for i in 0..<textureAtlas.textureNames.count {
            frames.append(textureAtlas.textureNamed(textureAtlas.textureNames[i]))
        }
        ball.run(SKAction.repeatForever(SKAction.animate(with: frames, timePerFrame: TimeInterval(0.2), resize: false, restore: true)))

        let platform = SKShapeNode(rectOf: CGSize(width: 200, height: 50))
        platform.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 200, height: 50))
        platform.physicsBody?.isDynamic = false
        platform.position = CGPoint(x: size.width / 2, y: size.height / 2 - 400)
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
