//
//  GameMode+Common.swift
//  star-dash
//
//  Created by Jason Qiu on 16/4/24.
//

import Foundation

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
