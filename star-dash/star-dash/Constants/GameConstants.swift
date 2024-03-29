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
        static let attackedByMonster = -20
        static let attackedByPlayer = -200
    }

    struct ScoreChange {
        static let pickupCollectible = 100
    }

    struct DamageImpulse {
        static let attackedByMonster = CGVector(dx: 500, dy: 0)
    }

    struct AttackImpulse {
        static let attackedByPlayer = CGVector(dx: 0, dy: 400)
    }
}
