//
//  RaceMode.swift
//  star-dash
//
//  Created by Jason Qiu on 4/4/24.
//

import CoreGraphics

class RaceMode: GameMode {
    var target: GameModeModifiable?
    let mapWidth: CGFloat

    init(target: GameModeModifiable? = nil, mapWidth: CGFloat) {
        self.target = target
        self.mapWidth = mapWidth
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
