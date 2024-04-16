//
//  GameModeConstants.swift
//  star-dash
//
//  Created by Jason Qiu on 16/4/24.
//

import Foundation

struct GameModeConstants {
    static let playerStartingPosition = CGPoint(x: 200, y: 200)

    struct LocalRaceMode {
        static let rankingScoreChangeMap = [
            1: 100,
            2: 50
        ]
    }
}
