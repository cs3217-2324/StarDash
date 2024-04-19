//
//  RaceMode.swift
//  star-dash
//
//  Created by Jason Qiu on 4/4/24.
//

import CoreGraphics
import Foundation

class RaceMode: GameMode {
    var target: GameModeModifiable?

    var numberOfPlayers: Int

    private var playerHasFinishLineScoreMap: [PlayerId: Bool] = [:]
    private var nextPlayerRanking = 1

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

        for playerId in target.playerIds() {
            playerHasFinishLineScoreMap[playerId] = false
        }
    }

    func update(by deltaTime: TimeInterval) {
        guard let target = target else {
            return
        }
        updateFinishLineScoreRule(target: target)
    }

    func hasGameEnded() -> Bool {
        guard let target = target else {
            return false
        }
        return haveAllPlayersFinishedGame(target: target)

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
}

// MARK: Game-mode specific rules
extension RaceMode {
    private func updateFinishLineScoreRule(target: GameModeModifiable) {
        guard let playerSystem = target.system(ofType: PlayerSystem.self),
              let scoreSystem = target.system(ofType: ScoreSystem.self) else {
            return
        }
        for (playerId, hasFinishLineScore) in playerHasFinishLineScoreMap {
            guard !hasFinishLineScore,
                  let hasPlayerFinishedGame =
                    playerSystem.hasPlayerFinishedGame(entityId: playerId) else {
                continue
            }
            guard hasPlayerFinishedGame else {
                continue
            }
            let scoreChange = GameModeConstants.LocalRaceMode.rankingScoreChangeMap[nextPlayerRanking] ?? 0
            scoreSystem.applyScoreChange(to: playerId, scoreChange: scoreChange)
            playerHasFinishLineScoreMap[playerId] = true
            nextPlayerRanking += 1
        }
    }
}
