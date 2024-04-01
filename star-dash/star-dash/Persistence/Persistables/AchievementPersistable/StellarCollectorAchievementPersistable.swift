//
//  StellarCollectorAchievementPersistable.swift
//  star-dash
//
//  Created by Ho Jun Hao on 1/4/24.
//

import Foundation

class StellarCollectorAchievementPersistable: AchievementPersistable {
    var playerId: Int
    var starsCollected: Int

    func toAchievement() -> Achievement {
        StellarCollectorAchievement(playerId: playerId, starsCollected: starsCollected)
    }
}
