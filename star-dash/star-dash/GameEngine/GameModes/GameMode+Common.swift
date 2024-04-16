//
//  GameMode+Common.swift
//  star-dash
//
//  Created by Jason Qiu on 16/4/24.
//

import Foundation

// MARK: Common game-mode setup
extension GameMode {
    func setupPlayers(target: GameModeModifiable) {
        for playerIndex in 0..<numberOfPlayers {
            EntityFactory.createAndAddPlayer(to: target,
                                             playerIndex: playerIndex,
                                             position: GameModeConstants.playerStartingPosition)
        }
    }
}

// MARK: Common game-mode checks
extension GameMode {
    func haveAllPlayersFinishedGame(target: GameModeModifiable) -> Bool {
        guard let playerSystem = target.system(ofType: PlayerSystem.self) else {
            return false
        }
        for playerId in target.playerIds() {
            guard let hasPlayerFinishedGame =
                    playerSystem.hasPlayerFinishedGame(entityId: playerId) else {
                continue
            }
            guard !hasPlayerFinishedGame else {
                return false
            }
        }
        return true
    }
}
