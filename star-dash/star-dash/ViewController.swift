//
//  ViewController.swift
//  star-dash
//
//  Created by Lau Rui han on 12/3/24.
//

import UIKit
import SDPhysicsEngine

class ViewController: UIViewController {

    var scene: SDScene?
    var renderer: Renderer?

    override func viewDidLoad() {
        super.viewDidLoad()

        let scene = GameScene(size: CGSize(width: 4_842, height: 1_040))
        scene.scaleMode = .aspectFill
        setupGame()
        self.scene = scene

        guard let renderer = MTKRenderer(scene: scene) else {
            return
        }

        renderer.createSinglePlayerView(at: self.view)
        self.renderer = renderer
    }

    func setupGame() {

        let background = GameSpriteObject(imageNamed: "GameBackground")
        background.position = CGPoint(x: size.width / 2, y: size.height / 2)
        background.zPosition = -1
        scene.addGameObject(background)

        let ball = GameSpriteObject(imageNamed: "PlayerRedNose")
        ball.size = CGSize(width: 100, height: 140)
        ball.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 60, height: 110))
        ball.position = CGPoint(x: size.width / 2, y: size.height / 2 + 200)
        scene.addGameObject(ball)

        // let textureAtlas = SKTextureAtlas(named: "PlayerRedNoseRun")
        // var frames = [SKTexture]()
        // for idx in 0..<textureAtlas.textureNames.count {
        //     frames.append(textureAtlas.textureNamed(textureAtlas.textureNames[idx]))
        // }
        // ball.run(SKAction.repeatForever(
        //     SKAction.animate(with: frames, timePerFrame: TimeInterval(0.2), resize: false, restore: true)
        // ))

        let platform = SKShapeNode(rectOf: CGSize(width: 200, height: 50))
        platform.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 200, height: 50))
        platform.physicsBody?.isDynamic = false
        platform.position = CGPoint(x: size.width / 2, y: size.height / 2 - 400)
        scene.addGameObject(platform)
    }
}
