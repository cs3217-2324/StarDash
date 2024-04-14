//
//  RaceMode.swift
//  star-dash
//
//  Created by Jason Qiu on 4/4/24.
//

import CoreGraphics

class LocalRaceMode: GameMode {
    var target: GameModeModifiable?
    let mapWidth: CGFloat

    init(mapWidth: CGFloat, target: GameModeModifiable? = nil) {
        self.mapWidth = mapWidth
        self.target = target
    }

    func setTarget(_ target: any GameModeModifiable) {
        self.target = target
    }

    func hasGameEnded() -> Bool {
        guard let target = target else {
            return false
        }
        return false
    }
}
