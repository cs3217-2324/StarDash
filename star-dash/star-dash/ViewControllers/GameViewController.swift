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
    var achievementManager: AchievementManager?

    override func viewDidLoad() {
        super.viewDidLoad()

        let gameEngine = createGameEngine()
        self.gameEngine = gameEngine

        let scene = createGameScene(of: gameEngine.mapSize)
        self.scene = scene

        self.gameBridge = GameBridge(entityManager: gameEngine, scene: scene)

        setupGame()
        setupBackground(in: scene)
        setupFlag(in: scene)
        setupBackButton()

        guard let renderer = MTKRenderer(scene: scene) else {
            return
        }
        renderer.viewDelegate = self
        renderer.setupViews(at: self.view, for: numberOfPlayers)
        self.renderer = renderer
    }

    @objc
    func backButtonTapped() {
        performSegue(withIdentifier: "BackSegue", sender: self)
    }

    private func createGameEngine() -> GameEngine {
        let levelSize = level?.size ?? RenderingConstants.defaultLevelSize
        return GameEngine(mapSize: levelSize, gameMode: RaceMode(mapWidth: levelSize.width))
    }

    private func createGameScene(of size: CGSize) -> GameScene {
        // GameScene size width extended for finish line
        let extendedSize = CGSize(
            width: size.width + RenderingConstants.levelSizeRightExtension,
            height: size.height)
        let scene = GameScene(size: extendedSize, for: numberOfPlayers)
        scene.scaleMode = .aspectFill
        scene.sceneDelegate = self
        return scene
    }
}

// MARK: Setup
extension GameViewController {
    private func setupGame() {
        guard let storageManager = self.storageManager,
              let gameEngine = self.gameEngine,
              let scene = self.scene,
              let level = self.level else {
            return
        }

        let entities = storageManager.getAllEntity(id: level.id)
        gameEngine.setupLevel(level: level, entities: entities, sceneSize: scene.size)
        gameEngine.setupPlayers(numberOfPlayers: self.numberOfPlayers)

        self.achievementManager = AchievementManager(withMap: gameEngine.playerIdEntityMap)

        if let achievementManager = self.achievementManager {
            gameEngine.registerListener(achievementManager)
        }
    }

    private func setupBackground(in scene: SDScene) {
        guard let level = self.level else {
            return
        }

        let background = SDSpriteObject(imageNamed: level.background)
        let backgroundWidth = background.size.width
        let backgroundHeight = background.size.height

        var remainingGameWidth = scene.size.width
        var numOfAddedBackgrounds = 0
        while remainingGameWidth > 0 {
            let background = SDSpriteObject(imageNamed: level.background)
            let offset = CGFloat(numOfAddedBackgrounds) * backgroundWidth
            background.position = CGPoint(x: backgroundWidth / 2 + offset, y: backgroundHeight / 2)
            background.zPosition = -1
            scene.addObject(background)

            remainingGameWidth -= backgroundWidth
            numOfAddedBackgrounds += 1
        }
    }

    private func setupFlag(in scene: SDScene) {
        guard let gameEngine = gameEngine else {
            return
        }
        let flag = SDSpriteObject(imageNamed: SpriteConstants.flag)
        flag.size = PhysicsConstants.Dimensions.flag
        flag.position = CGPoint(x: gameEngine.mapSize.width + flag.size.width / 2, y: 200)
        flag.zPosition = -1
        scene.addObject(flag)
    }

    private func setupBackButton() {
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
