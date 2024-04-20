//
//  GameModeFactory.swift
//  star-dash
//
//  Created by Lau Rui han on 19/4/24.
//

import Foundation
typealias GameModeMap = [GameModeType: GameMode]

class GameModeFactory {
    static let modeMap: GameModeMap = [
        .Timed: TimedMode(),
        .Race: RaceMode()
    ]
    static func toGameMode(gameModeType: GameModeType) -> GameMode {

        guard let gameMode = GameModeFactory.modeMap[gameModeType] else {
            return RaceMode()
        }
        return gameMode
    }
}
