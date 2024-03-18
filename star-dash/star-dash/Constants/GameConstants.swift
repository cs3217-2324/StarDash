//
//  GameConstants.swift
//  star-dash
//
//  Created by Jason Qiu on 18/3/24.
//

import Foundation

struct GameConstants {
    struct InitialHealth {
        static let player = 100
        static let monster = 100
    }

    struct HealthChange {
        static let attackedByMonster = -200
        static let attackedByPlayer = -20
    }

    struct ScoreChange {
        static let pickupCollectible = 100
    }
}
