//
//  PowerRangerAchievementPersistable.swift
//  star-dash
//
//  Created by Ho Jun Hao on 1/4/24.
//

import Foundation

class PowerRangerAchievementPersistable: AchievementPersistable {
    var playerId: Int
    var powerUpsUsed: Int

    func toAchievement() -> Achievement {
        PowerRangerAchievement(playerId: playerId, powerUpsUsed: powerUpsUsed)
    }
}
