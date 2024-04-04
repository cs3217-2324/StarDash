//
//  AchievementPersistable.swift
//  star-dash
//
//  Created by Ho Jun Hao on 1/4/24.
//

import Foundation

protocol AchievementPersistable: Codable {
    func toAchievement() -> Achievement
}
