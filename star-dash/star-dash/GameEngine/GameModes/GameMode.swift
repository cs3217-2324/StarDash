//
//  GameMode.swift
//  star-dash
//
//  Created by Jason Qiu on 4/4/24.
//

protocol GameMode {
    var target: GameModeModifiable? { get set }

    func setTarget(_ target: GameModeModifiable)
    func setup()
    func hasGameEnded() -> Bool
}

extension GameMode {
    func setup() {}
}
