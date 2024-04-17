//
//  SingleRaceMode.swift
//  star-dash
//
//  Created by Jason Qiu on 15/4/24.
//

import Foundation

class SingleRaceMode: GameMode {
    var target: GameModeModifiable?

    let numberOfPlayers = 1

    init(target: GameModeModifiable? = nil) {
        self.target = target
    }

    func setTarget(_ target: any GameModeModifiable) {
        self.target = target
    }

    func setupGameMode() {
        guard let target = target else {
            return
        }
        setupPlayers(target: target)
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
