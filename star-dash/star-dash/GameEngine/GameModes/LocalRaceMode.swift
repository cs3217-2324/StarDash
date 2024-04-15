//
//  LocalRaceMode.swift
//  star-dash
//
//  Created by Jason Qiu on 4/4/24.
//

import CoreGraphics

class LocalRaceMode: GameMode {
    var target: GameModeModifiable?

    let numberOfPlayers = 2

    init(target: GameModeModifiable? = nil) {
        self.target = target
    }

    func setTarget(_ target: any GameModeModifiable) {
        self.target = target
    }

    func hasGameEnded() -> Bool {
        guard let target = target,
              let playerSystem = target.system(ofType: PlayerSystem.self) else {
            return false
        }
        return playerSystem.haveAllPlayersFinishedGame()
    }
}
