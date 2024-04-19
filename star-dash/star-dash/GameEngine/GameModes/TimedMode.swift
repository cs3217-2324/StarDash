//
//  TimedMode.swift
//  star-dash
//
//  Created by Lau Rui han on 19/4/24.
//

import Foundation

class TimedMode: GameMode {
    var numberOfPlayers: Int
    var hasFinishLine = false
    var target: GameModeModifiable?
    var time: TimeInterval = 60
    private var isGameEnded = false

    init(target: GameModeModifiable? = nil, numberOfPlayers: Int = 2) {
        self.target = target
        self.numberOfPlayers = numberOfPlayers
    }

    func setTarget(_ target: GameModeModifiable) {
        self.target = target
    }

    func setupGameMode() {
        guard let target = target else {
            return
        }
        setupPlayers(target: target)
    }

    func update(by deltaTime: TimeInterval) {
        guard target != nil else {
            return
        }
        time -= deltaTime
        if time <= 0 && !isGameEnded {
            endGame()
        }
    }

    func hasGameEnded() -> Bool {
        isGameEnded
    }

    func results() -> GameResults? {
        guard let target = target,
              let scoreSystem = target.system(ofType: ScoreSystem.self),
              let spriteSystem = target.system(ofType: SpriteSystem.self) else {
            return nil
        }
        var gameResults = GameResults()
        for playerId in target.playerIds() {
            let spriteImage = spriteSystem.getImage(of: playerId) ?? SpriteConstants.playerRedNose
            let score = scoreSystem.score(of: playerId) ?? 0
            let playerResult = PlayerResult(spriteImage: spriteImage, result: CGFloat(score))
            gameResults.addPlayerResult(playerResult)
        }
        return gameResults
    }

    private func endGame() {
        isGameEnded = true
    }
}
