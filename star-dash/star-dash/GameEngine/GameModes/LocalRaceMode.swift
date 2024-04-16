//
//  LocalRaceMode.swift
//  star-dash
//
//  Created by Jason Qiu on 4/4/24.
//

import CoreGraphics
import Foundation

class LocalRaceMode: GameMode {
    var target: GameModeModifiable?

    let numberOfPlayers = 2

    init(target: GameModeModifiable? = nil) {
        self.target = target
    }

    func setTarget(_ target: any GameModeModifiable) {
        self.target = target
    }

    func update(by deltaTime: TimeInterval) {
        guard let target = target else {
            return
        }
        updateScoreRule(target: target)
    }

    func hasGameEnded() -> Bool {
        guard let target = target else {
            return false
        }
        return haveAllPlayersFinishedGame(target: target)

    }

    func results() -> GameResult {
        // get scores of all the playesr
        GameResult(displayText: "")
    }

    private func updateScoreRule(target: GameModeModifiable) {
        guard let scoreSystem = target.system(ofType: ScoreSystem.self) else {
            return
        }
        // add score to player when they cross finish line based on their rankings
    }
}
