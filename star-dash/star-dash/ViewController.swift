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
    var gameBridge: GameBridge?
    var gameEngine: GameEngine?

    override func viewDidLoad() {
        super.viewDidLoad()

        let scene = GameScene(size: CGSize(width: 4_842, height: 1_040))
        scene.scaleMode = .aspectFill
        scene.sceneDelegate = self
        self.scene = scene
        let gameEngine = GameEngine()
        self.gameEngine = gameEngine
        self.gameBridge = GameBridge(entityManager: gameEngine, scene: scene)

        setupGameEntities()

        guard let renderer = MTKRenderer(scene: scene) else {
            return
        }

        renderer.viewDelegate = self
        renderer.createSinglePlayerView(at: self.view)
        self.renderer = renderer
    }

    func setupGameEntities() {
        guard let scene = self.scene,
              let entityManager = gameEngine?.entityManager else {
            return
        }

        let background = SDSpriteObject(imageNamed: "GameBackground")
        background.position = CGPoint(x: scene.size.width / 2, y: scene.size.height / 2)
        background.zPosition = -1
        scene.addObject(background)

        let player = Player(
            playerIndex: 0,
            position: CGPoint(x: scene.size.width / 2, y: scene.size.height / 2 + 200),
            playerSprite: PlayerSprite.RedNose
        )
        player.setUpAndAdd(to: entityManager)

        let floor = Floor(position: CGPoint(x: scene.size.width / 2, y: scene.size.height / 2 - 400))
        floor.setUpAndAdd(to: entityManager)

        let collectible = Collectible.createCoinCollectible(
            position: CGPoint(x: scene.size.width / 2 + 30, y: scene.size.height / 2 - 100)
        )
        collectible.setUpAndAdd(to: entityManager)
    }
}

extension ViewController: SDSceneDelegate {

    func update(_ scene: SDScene, deltaTime: Double) {
        gameBridge?.syncToEntities()
        gameEngine?.update(by: deltaTime)
        gameBridge?.syncFromEntities()

        guard let gameInfo = gameEngine?.gameInfo() else {
            return
        }

        renderer?.updateOverlay(overlayInfo: OverlayInfo(
            score: gameInfo.playerScore
        ))
    }

    func contactOccured(objectA: SDObject, objectB: SDObject, contactPoint: CGPoint) {
        guard let entityA = gameBridge?.entityId(of: objectA.id),
              let entityB = gameBridge?.entityId(of: objectB.id) else {
            return
        }

        gameEngine?.handleCollision(entityA, entityB, at: contactPoint)
    }
}

extension ViewController: ViewDelegate {

    func joystickMoved(toLeft: Bool) {
        gameEngine?.handlePlayerMove(toLeft: toLeft)
    }

    func jumpButtonPressed() {
        gameEngine?.handlePlayerJump()
    }
}
