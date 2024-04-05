//
//  AchievementFactory.swift
//  star-dash
//
//  Created by Ho Jun Hao on 1/4/24.
//

import Foundation

struct AchievementFactory {
    static func createTwinkleStarAchievement(_ playerId: Int) -> TwinkleStarAchievement {
        TwinkleStarAchievement(playerId: playerId)
    }

    static func createStellarCollectorAchievement(_ playerId: Int) -> StellarCollectorAchievement {
        StellarCollectorAchievement(playerId: playerId)
    }

    static func createPowerRangerAchievement(_ playerId: Int) -> PowerRangerAchievement {
        PowerRangerAchievement(playerId: playerId)
    }
}
