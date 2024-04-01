//
//  AppDatabase.swift
//  star-dash
//
//  Created by Lau Rui han on 20/3/24.
//

import Foundation
import os.log
import SQLite

struct Database {
    static let DIR_DB = "StarDashDB"
    static let DB_NAME = "stardash.sqlite3"
    private let levelTable = Table("level")
    private let collectibleTable = Table("collectible")
    private let obstacleTable = Table("obstacle")
    private let toolTable = Table("tool")
    private let monsterTable = Table("monster")

    private let twinkleStarAchievementTable = Table("twinklestar")
    private let stellarCollectorAchievementTable = Table("stellarCollector")
    private let powerRangerAchievementTable = Table("powerranger")

    private var db: Connection?
    // Define a dictionary to map entity types to tables
    let tableMap: [ObjectIdentifier: Table]

    init() {
        tableMap = [
            ObjectIdentifier(CollectibleEntityPersistable.self): self.collectibleTable,
            ObjectIdentifier(ToolEntityPersistable.self): self.toolTable,
            ObjectIdentifier(ObstacleEntityPersistable.self): self.obstacleTable,
            ObjectIdentifier(MonsterEntityPersistable.self): self.monsterTable,
            ObjectIdentifier(TwinkleStarAchievementPersistable.self): self.twinkleStarAchievementTable,
            ObjectIdentifier(StellarCollectorAchievementPersistable.self): self.stellarCollectorAchievementTable,
            ObjectIdentifier(TwinkleStarAchievementPersistable.self): self.powerRangerAchievementTable
        ]

        if let docDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let dirPath = docDir.appendingPathComponent(Self.DIR_DB)

            do {
                try FileManager.default.createDirectory(
                    atPath: dirPath.path,
                    withIntermediateDirectories: true,
                    attributes: nil)
                let dbPath = dirPath.appendingPathComponent(Self.DB_NAME).path
                self.db = try Connection(dbPath)
                dropAllTables()
                createAllTables()
                insertJsonData()
                print("SQLiteDataStore init successfully at: \(dbPath) ")
            } catch {
                db = nil
                print("SQLiteDataStore init error: \(error)")
            }
        } else {
            db = nil
        }
    }

    private func dropAllTables() {
        guard let db = db else {
            return
        }
        do {
            try db.run(levelTable.drop())
            try db.run(obstacleTable.drop())
            try db.run(collectibleTable.drop())
            try db.run(toolTable.drop())
            try db.run(monsterTable.drop())

            // Comment out below to test for persistency
            try db.run(twinkleStarAchievementTable.drop())
            try db.run(stellarCollectorAchievementTable.drop())
            try db.run(powerRangerAchievementTable.drop())
        } catch {
            print("Error deleting table \(error)")
        }

    }

    private func createAllTables() {
        createLevelTable()
        createCollectibleTable()
        createToolTable()
        createMonsterTable()
        createObstacleTable()

        createAchievementTables()
    }

    private func createLevelTable() {
        guard let db = db else {
            return
        }
        let id = Expression<Int64>("id")
        let name = Expression<String>("name")
        let size = Expression<String>("size")
        do {
            try db.run( levelTable.create { table in
                table.column(id, primaryKey: true)
                table.column(name)
                table.column(size)
            })
            print("Level table created")
        } catch {
            print("Error creating table \(error)")
        }
    }

    private func createCollectibleTable() {
        guard let db = db else {
            return
        }
        let id = Expression<Int64>("id")
        let levelId = Expression<Int64>("levelId")
        let position = Expression<String>("position")
        let points = Expression<Int>("points")
        let size = Expression<String>("size")

        do {
            try db.run( collectibleTable.create { table in
                table.column(id, primaryKey: .autoincrement)
                table.column(levelId)
                table.column(position)
                table.column(points)
                table.column(size)

            })
            print("Collectible table created")
        } catch {
            print("Error creating table \(error)")
        }
    }

    private func createObstacleTable() {
        guard let db = db else {
            return
        }
        let id = Expression<Int64>("id")
        let levelId = Expression<Int64>("levelId")
        let position = Expression<String>("position")
        let size = Expression<String>("size")

        do {
            try db.run( obstacleTable.create { table in
                table.column(id, primaryKey: .autoincrement)
                table.column(levelId)
                table.column(position)
                table.column(size)

            })
            print("Obstacle table created")
        } catch {
            print("Error creating table \(error)")
        }
    }

    private func createToolTable() {
        guard let db = db else {
            return
        }
        let id = Expression<Int64>("id")
        let levelId = Expression<Int64>("levelId")
        let position = Expression<String>("position")
        let size = Expression<String>("size")

        do {
            try db.run( toolTable.create { table in
                table.column(id, primaryKey: .autoincrement)
                table.column(levelId)
                table.column(position)
                table.column(size)

            })
            print("Tool table created")
        } catch {
            print("Error creating table \(error)")
        }
    }
    private func createMonsterTable() {
        guard let db = db else {
            return
        }
        let id = Expression<Int64>("id")
        let levelId = Expression<Int64>("levelId")
        let position = Expression<String>("position")
        let size = Expression<String>("size")
        let health = Expression<Int>("health")

        do {
            try db.run( monsterTable.create { table in
                table.column(id, primaryKey: .autoincrement)
                table.column(levelId)
                table.column(position)
                table.column(size)
                table.column(health)

            })
            print("Monster table created")
        } catch {
            print("Error creating table \(error)")
        }
    }

    func insert(persistable: LevelPersistable) {
        guard let database = db else {
            return
        }

        do {
            let insert = try self.levelTable.insert(persistable)
            try database.run(insert)
        } catch {
            print("Error saving level \(error)")
        }
    }

    func insert<T: EntityPersistable>(persistable: T) {
        guard let database = db else {
            return
        }

        do {
            // Get the corresponding table for the type
            guard let table = self.tableMap[ObjectIdentifier(T.self)] else {
                print("Unsupported entity type")
                return
            }

            let insert = try table.insert(persistable)
            try database.run(insert)
        } catch {
            print("Error saving level \(error)")
        }
    }

}

extension Database {
    func insertJsonData() {
        if let fileURL = Bundle.main.url(forResource: "data", withExtension: "json") {
            // Read JSON data from the file
            do {
                let jsonData = try Data(contentsOf: fileURL)
                // Decode JSON data into LevelData
                let levelData = try JSONDecoder().decode(LevelData.self, from: jsonData)
                let levelPersistable = LevelPersistable(
                    id: levelData.id,
                    name: levelData.name,
                    size: levelData.size
                )
                insert(persistable: levelPersistable)
                for persistable in levelData.collectibles {
                    insert(persistable: persistable)
                }
                for persistable in levelData.tools {
                    insert(persistable: persistable)
                }
                for persistable in levelData.obstacles {
                    insert(persistable: persistable)
                }
                for persistable in levelData.monsters {
                    insert(persistable: persistable)
                }

            } catch {
                print("Error reading or decoding JSON: \(error)")
            }
        } else {
            print("JSON file not found.")
        }
    }

    func getLevelPersistable(id: Int64) -> LevelPersistable? {
        guard let database = db else {
                    return nil
                }
        let idColumn = Expression<Int64>("id")
                do {
                    let loadedLevel: [LevelPersistable] =
                    try database.prepare(levelTable.filter(id == idColumn)).map { row in
                        let persistable: LevelPersistable = try row.decode()
                        return persistable

                    }
                    if loadedLevel.isEmpty {
                        return nil
                    }
                    return loadedLevel[0]

                } catch {
                    print("Error fetching levels \(error)")
                    return nil
                }
    }

    func getAllEntities(levelId: Int64) -> [EntityPersistable] {
        guard let database = db else {
            return []
        }
        var entities: [EntityPersistable] = []
        let levelIdColumn = Expression<Int64>("levelId")
        do {
            entities += try database.prepare(collectibleTable.filter(levelId == levelIdColumn)).map { row in
                let persistable: CollectibleEntityPersistable = try row.decode()
                return persistable
            }
            entities += try database.prepare(toolTable.filter(levelId == levelIdColumn)).map { row in
                let persistable: ToolEntityPersistable = try row.decode()
                return persistable
            }
            entities += try database.prepare(obstacleTable.filter(levelId == levelIdColumn)).map { row in
                let persistable: ObstacleEntityPersistable = try row.decode()
                return persistable
            }
            entities += try database.prepare(monsterTable.filter(levelId == levelIdColumn)).map { row in
                let persistable: MonsterEntityPersistable = try row.decode()
                return persistable
            }
        } catch {
            print("Error retriving \(error)")
        }

        return entities
    }
}

extension Database {
    func getAllAchievements(of playerId: Int) -> [AchievementPersistable] {
        var achievements: [AchievementPersistable] = []

        guard let twinkleStar = getTwinkleStar(of: playerId),
              let stellarCollector = getStellarCollector(of: playerId),
              let powerRanger = getPowerRanger(of: playerId) else {
            return achievements
        }

        achievements.append(twinkleStar)
        achievements.append(stellarCollector)
        achievements.append(powerRanger)

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
                // Update existing row
                let update = table.update(hasCollectedStarExprssion <- achievement.hasCollectedStar)
                try db.run(update)
                print("TwinkleStar achievement updated successfully")
            } else {
                // Insert new row
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
                // Update existing row
                let update = table.update(starsCollectedStarExprssion <- Int64(achievement.starsCollected))
                try db.run(update)
                print("StellarCollector achievement updated successfully")
            } else {
                // Insert new row
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
                // Update existing row
                let update = table.update(powerUpsUsedStarExprssion <- Int64(achievement.powerUpsUsed))
                try db.run(update)
                print("PowerRanger achievement updated successfully")
            } else {
                // Insert new row
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

    private func getTwinkleStar(of playerId: Int) -> TwinkleStarAchievementPersistable? {
        guard let db = db else {
            return nil
        }

        let playerIdExpression = Expression<Int64>("playerId")

        let table = twinkleStarAchievementTable.filter(playerIdExpression == Int64(playerId))

        do {
            if let row = try db.prepare(table).first(where: { _ in true }) {
                let persistable: TwinkleStarAchievementPersistable = try row.decode()
                return persistable
            } else {
                return nil
            }
        } catch {
            print("Error fetching TwinkleStar achievement: \(error)")
            return nil
        }
    }

    private func getStellarCollector(of playerId: Int) -> StellarCollectorAchievementPersistable? {
        guard let db = db else {
            return nil
        }

        let playerIdExpression = Expression<Int64>("playerId")

        let table = stellarCollectorAchievementTable.filter(playerIdExpression == Int64(playerId))

        do {
            if let row = try db.prepare(table).first(where: { _ in true }) {
                let persistable: StellarCollectorAchievementPersistable = try row.decode()
                return persistable
            } else {
                return nil
            }
        } catch {
            print("Error fetching StellarCollector achievement: \(error)")
            return nil
        }
    }

    private func getPowerRanger(of playerId: Int) -> PowerRangerAchievementPersistable? {
        guard let db = db else {
            return nil
        }

        let playerIdExpression = Expression<Int64>("playerId")

        let table = powerRangerAchievementTable.filter(playerIdExpression == Int64(playerId))

        do {
            if let row = try db.prepare(table).first(where: { _ in true }) {
                let persistable: PowerRangerAchievementPersistable = try row.decode()
                return persistable
            } else {
                return nil
            }
        } catch {
            print("Error fetching PowerRanger achievement: \(error)")
            return nil
        }
    }

    private func createAchievementTables() {
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
            print("twinklestar table created")

            try db.run( stellarCollectorAchievementTable.create { table in
                table.column(playerId, primaryKey: true)
                table.column(starsCollected)
            })
            print("stellarcollector table created")

            try db.run( powerRangerAchievementTable.create { table in
                table.column(playerId, primaryKey: true)
                table.column(powerUpsUsed)
            })
            print("powerranger table created")
        } catch {
           print("Error creating table: \(error)")
        }
    }
}
