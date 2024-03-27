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
    var storageManager: StorageManager?

    override func viewDidLoad() {
        super.viewDidLoad()

        let scene = GameScene(size: CGSize(width: 4_842, height: 1_040))
        scene.scaleMode = .aspectFill
        scene.sceneDelegate = self
        self.scene = scene
        let gameEngine = GameEngine()
        self.gameEngine = gameEngine
        self.gameBridge = GameBridge(entityManager: gameEngine, scene: scene)
        self.storageManager = StorageManager()
        setupGameEntities()

        guard let renderer = MTKRenderer(scene: scene) else {
            return
        }

        renderer.viewDelegate = self
        renderer.createSinglePlayerView(at: self.view)
        self.renderer = renderer
    }

    func setupGameEntities() {
        guard let scene = self.scene else {
            return
        }

        let camera = SDCameraObject()
        camera.position = CGPoint(x: scene.size.width / 2, y: scene.size.height / 2)
        scene.addCameraObject(camera)

        let background = SDSpriteObject(imageNamed: "GameBackground")
        background.position = CGPoint(x: scene.size.width / 2, y: scene.size.height / 2)
        background.zPosition = -1
        scene.addObject(background)

        let player = Player(playerIndex: 0,
                            position: CGPoint(x: 100, y: scene.size.height / 2 + 200),
                            playerSprite: PlayerSprite.RedNose)
        let floor = Floor(position: CGPoint(x: scene.size.width / 2, y: scene.size.height / 2 - 400))
        let collectible = Collectible.createStarCollectible(position: CGPoint(x: scene.size.width / 2 + 30,
                                                                              y: scene.size.height / 2 - 100))
        gameEngine?.add(entity: player)
        gameEngine?.add(entity: floor)
        gameEngine?.add(entity: collectible)

        if let level = self.storageManager?.getLevel(id: 0) {
            for entity in level.entities {
                gameEngine?.add(entity: entity)
            }
        }
    }
}

extension ViewController: SDSceneDelegate {

    func update(_ scene: SDScene, deltaTime: Double) {
        gameBridge?.syncToEntities()
        gameEngine?.update(by: deltaTime)
        gameBridge?.syncFromEntities()

        updateCameraObjectPosition(scene)
        updateOverlay()
    }

    private func updateCameraObjectPosition(_ scene: SDScene) {
        guard let playerPosition = gameEngine?.playerPosition() else {
            return
        }
        let screenSize = UIScreen.main.bounds.size
        let halfScreenWidth = screenSize.width / 2
        if playerPosition.x >= halfScreenWidth + 200 {
            scene.setCameraObjectXPosition(to: playerPosition.x)
        } else {
            scene.setCameraObjectXPosition(to: halfScreenWidth + 200)
        }
    }

    private func updateOverlay() {
        guard let gameInfo = gameEngine?.gameInfo() else {
            return
        }

        renderer?.updateOverlay(overlayInfo: OverlayInfo(
            score: gameInfo.playerScore
        ))
    }

    func contactOccurred(objectA: SDObject, objectB: SDObject, contactPoint: CGPoint) {
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

    func joystickReleased() {
        gameEngine?.handlePlayerStoppedMoving()
    }

    func jumpButtonPressed() {
        gameEngine?.handlePlayerJump()
    }
}
