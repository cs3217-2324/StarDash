//
//  GameMode.swift
//  star-dash
//
//  Created by Jason Qiu on 4/4/24.
//

import CoreGraphics

protocol GameMode {
    var target: GameModeModifiable? { get set }
    
    // Number of players on a single device screen
    var numberOfPlayers: Int { get }

    func setTarget(_ target: GameModeModifiable)
    func setupGameMode()
    func setupPlayers()
    func hasGameEnded() -> Bool
}

extension GameMode {
    func setupGameMode() {}

    func setupPlayers() {
        guard let target = target else {
            return
        }
        for playerIndex in 0..<numberOfPlayers {
            let position = CGPoint(x: 200, y: 200)
            EntityFactory.createAndAddPlayer(to: target,
                                             playerIndex: playerIndex,
                                             position: position)
        }
    }
}
