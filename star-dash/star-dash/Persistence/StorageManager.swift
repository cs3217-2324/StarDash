//
//  StorageManager.swift
//  star-dash
//
//  Created by Lau Rui han on 20/3/24.
//

import Foundation

class StorageManager {
    let database: Database

    init() {
        database = Database()
    }

    func loadLevel(id: Int64, into entityManager: EntityManagerInterface) {
        let entityPersistables = self.database.getAllEntities(levelId: id)

        entityPersistables.forEach { $0.addTo(entityManager) }
    }

    func loadAchievements(of id: Int) -> PlayerAchievements? {
        var achievements: [Achievement] = []
        let playerAchievements = self.database.getAllAchievements(of: id)

        playerAchievements.forEach { achievements.append($0.toAchievement()) }

        guard !achievements.isEmpty else {
            return nil
        }

        return PlayerAchievements(playerId: id, achievements: achievements)
    }

    func upsert(achievement: TwinkleStarAchievement) {
        self.database.upsertTwinkleStar(achievement)
    }

    func upsert(achievement: StellarCollectorAchievement) {
        self.database.upsertStellarCollector(achievement)
    }

    func upsert(achievement: PowerRangerAchievement) {
        self.database.upsertPowerRanger(achievement)
    }
}
