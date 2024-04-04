//
//  Database+Achievements.swift
//  star-dash
//
//  Created by Ho Jun Hao on 2/4/24.
//

import Foundation
import os.log
import SQLite

extension Database {
    func getAllAchievements(of playerId: Int) -> [AchievementPersistable] {
        var achievements: [AchievementPersistable] = []

        achievements += getAchievement(TwinkleStarAchievementPersistable.self,
                                       table: twinkleStarAchievementTable,
                                       playerId: playerId).map { [$0] } ?? []
        achievements += getAchievement(StellarCollectorAchievementPersistable.self,
                                       table: stellarCollectorAchievementTable,
                                       playerId: playerId).map { [$0] } ?? []
        achievements += getAchievement(PowerRangerAchievementPersistable.self,
                                       table: powerRangerAchievementTable,
                                       playerId: playerId).map { [$0] } ?? []

        return achievements
    }

    func getAllAchievements() -> [AchievementPersistable] {
        var achievements: [AchievementPersistable] = []

        achievements += getAchievement(TwinkleStarAchievementPersistable.self,
                                       table: twinkleStarAchievementTable)
        achievements += getAchievement(StellarCollectorAchievementPersistable.self,
                                       table: stellarCollectorAchievementTable)
        achievements += getAchievement(PowerRangerAchievementPersistable.self,
                                       table: powerRangerAchievementTable)

        return achievements
    }

    func upsertTwinkleStar(_ achievement: TwinkleStarAchievement) {
        guard let db = db else {
            return
        }

        let playerIdExpression = Expression<Int64>("playerId")
        let hasCollectedStarExprssion = Expression<Bool>("hasCollectedStar")
        let table = twinkleStarAchievementTable.filter(playerIdExpression == Int64(achievement.playerId))

        do {
            if try db.scalar(table.count) > 0 {
                let update = table.update(hasCollectedStarExprssion <- achievement.hasCollectedStar)
                try db.run(update)
                print("TwinkleStar achievement updated successfully")
            } else {
                try db.run(twinkleStarAchievementTable.insert(
                        playerIdExpression <- Int64(achievement.playerId),
                        hasCollectedStarExprssion <- achievement.hasCollectedStar
                    ))
                print("TwinkleStar achievement inserted successfully")
            }
        } catch {
            print("Error upserting TwinkleStar achievement: \(error)")
        }
    }

    func upsertStellarCollector(_ achievement: StellarCollectorAchievement) {
        guard let db = db else {
            return
        }

        let playerIdExpression = Expression<Int64>("playerId")
        let starsCollectedStarExprssion = Expression<Int64>("starsCollected")
        let table = stellarCollectorAchievementTable.filter(playerIdExpression == Int64(achievement.playerId))

        do {
            if try db.scalar(table.count) > 0 {
                let update = table.update(starsCollectedStarExprssion <- Int64(achievement.starsCollected))
                try db.run(update)
                print("StellarCollector achievement updated successfully")
            } else {
                try db.run(stellarCollectorAchievementTable.insert(
                        playerIdExpression <- Int64(achievement.playerId),
                        starsCollectedStarExprssion <- Int64(achievement.starsCollected)
                    ))
                print("StellarCollector achievement inserted successfully")
            }
        } catch {
            print("Error upserting StellarCollector achievement: \(error)")
        }
    }

    func upsertPowerRanger(_ achievement: PowerRangerAchievement) {
        guard let db = db else {
            return
        }

        let playerIdExpression = Expression<Int64>("playerId")
        let powerUpsUsedStarExprssion = Expression<Int64>("powerUpsUsed")
        let table = powerRangerAchievementTable.filter(playerIdExpression == Int64(achievement.playerId))

        do {
            if try db.scalar(table.count) > 0 {
                let update = table.update(powerUpsUsedStarExprssion <- Int64(achievement.powerUpsUsed))
                try db.run(update)
                print("PowerRanger achievement updated successfully")
            } else {
                try db.run(powerRangerAchievementTable.insert(
                        playerIdExpression <- Int64(achievement.playerId),
                        powerUpsUsedStarExprssion <- Int64(achievement.powerUpsUsed)
                    ))
                print("PowerRanger achievement inserted successfully")
            }
        } catch {
            print("Error upserting PowerRanger achievement: \(error)")
        }
    }

    func getAchievement<T: AchievementPersistable>(_ type: T.Type, table: Table, playerId: Int) -> T? {
        guard let db = db else {
            return nil
        }

        let playerIdExpression = Expression<Int64>("playerId")
        let filteredTable = table.filter(playerIdExpression == Int64(playerId))

        do {
            if let row = try db.prepare(filteredTable).first(where: { _ in true }) {
                let persistable: T = try row.decode()
                return persistable
            } else {
                return nil
            }
        } catch {
            print("Error fetching \(T.self) achievement: \(error)")
            return nil
        }
    }

    func getAchievement<T: AchievementPersistable>(_ type: T.Type, table: Table) -> [T] {
        guard let db = db else {
            return []
        }

        do {
            let rows = try db.prepare(table)
            let achievements: [T] = try rows.map { try $0.decode() }
            return achievements
        } catch {
            print("Error fetching \(T.self) achievements: \(error)")
            return []
        }
    }

    func createAchievementTables() {
        guard let db = db else {
           return
        }

        let playerId = Expression<Int64>("playerId")
        let hasCollected = Expression<Bool>("hasCollectedStar")
        let starsCollected = Expression<Int64>("starsCollected")
        let powerUpsUsed = Expression<Int64>("powerUpsUsed")

        do {
            try db.run( twinkleStarAchievementTable.create { table in
               table.column(playerId, primaryKey: true)
               table.column(hasCollected)
            })

            try db.run( stellarCollectorAchievementTable.create { table in
                table.column(playerId, primaryKey: true)
                table.column(starsCollected)
            })

            try db.run( powerRangerAchievementTable.create { table in
                table.column(playerId, primaryKey: true)
                table.column(powerUpsUsed)
            })
            print("All Achievement tables created")
        } catch {
           print("Error creating table: \(error)")
        }
    }
}
