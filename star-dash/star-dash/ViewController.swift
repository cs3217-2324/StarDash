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
        renderer.setupViews(at: self.view, for: 2)
        self.renderer = renderer
    }

    func setupGameEntities() {
        guard let scene = self.scene,
              let gameEngine = self.gameEngine else {
            return
        }

        let background = SDSpriteObject(imageNamed: "GameBackground")
        background.position = CGPoint(x: scene.size.width / 2, y: scene.size.height / 2)
        background.zPosition = -1
        scene.addObject(background)

        EntityFactory.createAndAddPlayer(to: gameEngine,
                                         playerIndex: 0,
                                         position: CGPoint(x: 100, y: scene.size.height / 2 + 200))

        EntityFactory.createAndAddPlayer(to: gameEngine,
                                         playerIndex: 1,
                                         position: CGPoint(x: scene.size.width / 2, y: scene.size.height / 2 + 200))

        EntityFactory.createAndAddFloor(to: gameEngine,
                                        position: CGPoint(x: scene.size.width / 2, y: scene.size.height / 2 - 400),
                                        size: CGSize(width: 8_000, height: 10))

        EntityFactory.createAndAddCollectible(to: gameEngine,
                                              position: CGPoint(x: scene.size.width / 2 + 30,
                                                                y: scene.size.height / 2 - 100),
                                              points: EntityConstants.StarCollectible.points,
                                              size: EntityConstants.StarCollectible.size)

        self.storageManager?.loadLevel(id: 0, into: gameEngine)

        let achievementManager = AchievementManager.shared
        gameEngine.registerListener(achievementManager)
        achievementManager.setup(withMap: gameEngine.playerIdEntityMap)
    }
}

extension ViewController: SDSceneDelegate {

    func update(_ scene: SDScene, deltaTime: Double) {
        gameBridge?.syncToEntities()
        gameEngine?.update(by: deltaTime)
        gameBridge?.syncFromEntities()
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

    func joystickMoved(toLeft: Bool, playerIndex: Int) {
        gameEngine?.handlePlayerMove(toLeft: toLeft, playerIndex: playerIndex)
    }

    func joystickReleased(playerIndex: Int) {
        gameEngine?.handlePlayerStoppedMoving(playerIndex: playerIndex)
    }

    func jumpButtonPressed(playerIndex: Int) {
        gameEngine?.handlePlayerJump(playerIndex: playerIndex)
    }

    func overlayInfo(forPlayer playerIndex: Int) -> OverlayInfo? {
        guard let gameInfo = gameEngine?.gameInfo(forPlayer: playerIndex) else {
            return nil
        }

        return OverlayInfo(
            score: gameInfo.playerScore,
            playersInfo: gameInfo.playersInfo
        )
    }
}
