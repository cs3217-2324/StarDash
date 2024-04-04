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

    func getLevelSize(id: Int64) -> CGSize? {
        self.database.getLevelPersistable(id: id)?.size
    }

    func getLevels() -> [LevelPersistable] {
        self.database.getLevels()
    }

    func getAllEntity(id: Int64) -> [EntityPersistable] {
        self.database.getAllEntities(levelId: id)
    }

    func loadLevel(id: Int64, into entityManager: EntityManagerInterface) {
        let entityPersistables = self.database.getAllEntities(levelId: id)

        entityPersistables.forEach { $0.addTo(entityManager) }
    }

    func loadAchievements(of id: Int) -> [Achievement] {
        var achievements: [Achievement] = []
        let playerAchievements = self.database.getAllAchievements(of: id)

        playerAchievements.forEach { achievements.append($0.toAchievement()) }

        return achievements
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
