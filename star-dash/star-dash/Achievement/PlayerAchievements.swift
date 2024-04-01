//
//  PlayerAchievements.swift
//  star-dash
//
//  Created by Ho Jun Hao on 1/4/24.
//

import Foundation

class PlayerAchievements {
    let playerId: Int
    let achievements: [Achievement]
    
    init(playerId: Int, achievements: [Achievement]) {
        self.playerId = playerId
        self.achievements = achievements
    }
}
