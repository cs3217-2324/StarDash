//
//  TwinkleStarAchievementPersistable.swift
//  star-dash
//
//  Created by Ho Jun Hao on 1/4/24.
//

import Foundation

class TwinkleStarAchievementPersistable: AchievementPersistable {
    var playerId: Int
    var hasCollectedStar: Bool

    func toAchievement() -> Achievement {
        TwinkleStarAchievement(playerId: playerId, hasCollectedStar: hasCollectedStar)
    }
}
