//
//  AchievementFactory.swift
//  star-dash
//
//  Created by Ho Jun Hao on 1/4/24.
//

import Foundation

struct AchievementFactory {
    private static let availableAchievements: [ObjectIdentifier: (Int) -> Achievement] = [
        ObjectIdentifier(TwinkleStarAchievement.self): createTwinkleStarAchievement
    ]

    static func createAllDefault(for id: Int) -> PlayerAchievements {
        var achievements: [Achievement] = []

        availableAchievements.values.forEach { achievements.append($0(id)) }

        return PlayerAchievements(playerId: id, achievements: achievements)
    }

    static func createTwinkleStarAchievement(_ playerId: Int) -> TwinkleStarAchievement {
        TwinkleStarAchievement(playerId: playerId)
    }
}
