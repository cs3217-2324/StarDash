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

    func results() -> GameResult {
        GameResult(displayText: "")
    }
}
