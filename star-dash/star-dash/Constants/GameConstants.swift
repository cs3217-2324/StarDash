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

    struct Hook {
        static let deltaPositionVector = CGVector(dx: 10, dy: 10)
        static let deltaAngle: Double = 3
        static let minLength: Double = 80
        static let maxLength: Double = 600
        static let defaultRetractLength: Double = 70
        static let defaultSwingAngle: Double = 135
    }
}
