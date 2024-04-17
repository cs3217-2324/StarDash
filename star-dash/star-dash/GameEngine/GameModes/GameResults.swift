//
//  GameResults.swift
//  star-dash
//
//  Created by Jason Qiu on 14/4/24.
//

import Foundation

struct GameResults {
    private(set) var playerResults: [PlayerResult] = []

    mutating func addPlayerResult(_ playerResult: PlayerResult) {
        playerResults.append(playerResult)
    }
}
