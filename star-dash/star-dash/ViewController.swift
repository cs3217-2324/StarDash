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
    var renderSynchronizer: RenderSynchronizer?
    var gameEngine: GameEngine?

    override func viewDidLoad() {
        super.viewDidLoad()

        let scene = GameScene(size: CGSize(width: 4_842, height: 1_040))
        scene.scaleMode = .aspectFill
        self.scene = scene
        let gameEngine = GameEngine(scene: scene)
        self.gameEngine = gameEngine
        self.renderSynchronizer = RenderSynchronizer(entitiesManager: gameEngine.entitiesManager)

        setupGame()

        guard let renderer = MTKRenderer(scene: scene) else {
            return
        }

        renderer.createSinglePlayerView(at: self.view)
        self.renderer = renderer
    }

    func setupGame() {
        guard let scene = self.scene else {
            return
        }

        let background = SDSpriteObject(imageNamed: "GameBackground")
        background.position = CGPoint(x: scene.size.width / 2, y: scene.size.height / 2)
        background.zPosition = -1
        scene.addObject(background)

        let ball = SDSpriteObject(imageNamed: "PlayerRedNose")
        ball.size = CGSize(width: 100, height: 140)
        ball.physicsBody = SDPhysicsBody(rectangleOf: CGSize(width: 60, height: 110))
        ball.position = CGPoint(x: scene.size.width / 2, y: scene.size.height / 2 + 200)
        scene.addObject(ball)

        // let textureAtlas = SKTextureAtlas(named: "PlayerRedNoseRun")
        // var frames = [SKTexture]()
        // for idx in 0..<textureAtlas.textureNames.count {
        //     frames.append(textureAtlas.textureNamed(textureAtlas.textureNames[idx]))
        // }
        // ball.run(SKAction.repeatForever(
        //     SKAction.animate(with: frames, timePerFrame: TimeInterval(0.2), resize: false, restore: true)
        // ))

        let platform = SDObject()
        platform.physicsBody = SDPhysicsBody(rectangleOf: CGSize(width: 200, height: 50))
        platform.physicsBody?.isDynamic = false
        platform.position = CGPoint(x: scene.size.width / 2, y: scene.size.height / 2 - 400)
        scene.addObject(platform)
    }
}

extension ViewController: SDSceneDelegate {
    
    func update(_ SDScene: scene, deltaTime: TimeInterval) {
        // TODO: Sync SDObjects into Entities
        // TODO: Update Game Logic
        // TODO: Sync Entities into SDObjects
    }
}
