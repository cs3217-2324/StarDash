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
    var gameMode: Int = 0
    var level: LevelPersistable?
    var numberOfPlayers: Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()

        let gameEngine = createGameEngine()
        self.gameEngine = gameEngine

        let scene = createGameScene(of: gameEngine.mapSize)
        self.scene = scene

        self.gameBridge = GameBridge(entityManager: gameEngine, scene: scene)

        setupGame()

        guard let renderer = MTKRenderer(scene: scene) else {
            return
        }

        renderer.viewDelegate = self
        renderer.setupViews(at: self.view, for: gameMode)
        self.renderer = renderer
    }

    private func createGameEngine() -> GameEngine {
        let levelSize = self.storageManager?.getLevelSize(id: 0) ?? CGSize(width: 4_842, height: 1_040)
        return GameEngine(mapSize: levelSize)
    }

    private func createGameScene(of size: CGSize) -> GameScene {
        var playerScreenSize = UIScreen.main.bounds.size
        if gameMode == 2 {
            playerScreenSize = CGSize(width: playerScreenSize.height, height: playerScreenSize.width / 2)
        }
        let scene = GameScene(size: size, playerScreenSize: playerScreenSize)
        scene.scaleMode = .aspectFill
        scene.sceneDelegate = self
        if let level = level {
            scene.setUpBackground(backgroundImage: level.background)
        }
        return scene
    }

    private func setupGame() {
        guard let storageManager = self.storageManager,
              let gameEngine = self.gameEngine,
              let level = self.level else {
            return
        }

        let entities = storageManager.getAllEntity(id: level.id)
        gameEngine.setupLevel(level: level, entities: entities )
        gameEngine.setupPlayers(numberOfPlayers: self.numberOfPlayers)
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

    func hookButtonPressed(playerIndex: Int) {
        gameEngine?.handlePlayerHook(playerIndex: playerIndex)
    }

    func overlayInfo(forPlayer playerIndex: Int) -> OverlayInfo? {
        guard let gameInfo = gameEngine?.gameInfo(forPlayer: playerIndex) else {
            return nil
        }

        return OverlayInfo(
            score: gameInfo.playerScore,
            playersInfo: gameInfo.playersInfo,
            mapSize: gameInfo.mapSize
        )
    }
}
