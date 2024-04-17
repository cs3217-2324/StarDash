//
//  GameMode.swift
//  star-dash
//
//  Created by Jason Qiu on 4/4/24.
//

import CoreGraphics
import Foundation

protocol GameMode {
    var target: GameModeModifiable? { get set }

    // Number of players on a single device screen
    var numberOfPlayers: Int { get }

    func setTarget(_ target: GameModeModifiable)
    func setupGameMode()
    func update(by deltaTime: TimeInterval)
    func hasGameEnded() -> Bool
    func results() -> GameResults?
}

extension GameMode {
    func setupGameMode() {}

    func update(by deltaTime: TimeInterval) {}
}
