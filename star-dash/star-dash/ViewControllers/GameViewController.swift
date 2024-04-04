//
//  ViewController.swift
//  star-dash
//
//  Created by Lau Rui han on 12/3/24.
//

import UIKit
import SDPhysicsEngine

class GameViewController: UIViewController {
    var scene: SDScene?
    var renderer: Renderer?
    var gameBridge: GameBridge?
    var gameEngine: GameEngine?
    var storageManager: StorageManager?
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
        renderer.setupViews(at: self.view, for: numberOfPlayers)
        self.renderer = renderer

        let backButton = UIButton(type: .system)
            backButton.setTitle("Back", for: .normal)
            backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
            self.view.addSubview(backButton)
            backButton.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
                backButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            ])
    }

    @objc
    func backButtonTapped() {
        performSegue(withIdentifier: "BackSegue", sender: self)
    }

    private func createGameEngine() -> GameEngine {
        let levelSize = level?.size ?? RenderingConstants.defaultLevelSize

        // Level size width extended for extra buffer and finish line
        let extendedLevelSize = CGSize(
            width: levelSize.width
                + RenderingConstants.levelSizeLeftExtension + RenderingConstants.levelSizeRightExtension,
            height: levelSize.height)
        return GameEngine(mapSize: extendedLevelSize)
    }

    private func createGameScene(of size: CGSize) -> GameScene {
        let scene = GameScene(size: size, for: numberOfPlayers)
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

extension GameViewController: SDSceneDelegate {

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

extension GameViewController: ViewDelegate {

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
