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
    private let monsterTable = Table("monster")
    private let powerUpBoxTable = Table("powerUpBox")
    private let wallTable = Table("Wall")

    let twinkleStarAchievementTable = Table("twinklestar")
    let stellarCollectorAchievementTable = Table("stellarCollector")
    let powerRangerAchievementTable = Table("powerranger")

    var db: Connection?

    // Define a dictionary to map entity types to tables
    let tableMap: [ObjectIdentifier: Table]

    init() {
        tableMap = [
            ObjectIdentifier(CollectibleEntityPersistable.self): self.collectibleTable,
            ObjectIdentifier(ObstacleEntityPersistable.self): self.obstacleTable,
            ObjectIdentifier(MonsterEntityPersistable.self): self.monsterTable,
            ObjectIdentifier(PowerUpBoxEntityPersistable.self): self.powerUpBoxTable,
            ObjectIdentifier(WallEntityPersistable.self): self.wallTable,
            ObjectIdentifier(TwinkleStarAchievementPersistable.self): self.twinkleStarAchievementTable,
            ObjectIdentifier(StellarCollectorAchievementPersistable.self): self.stellarCollectorAchievementTable,
            ObjectIdentifier(PowerRangerAchievementPersistable.self): self.powerRangerAchievementTable
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
                insertJsonData(filename: "level1")
                insertJsonData(filename: "level2")
                insertJsonData(filename: "level3")
                print("SQLiteDataStore init successfully at: \(dbPath) ")
            } catch {
                print("SQLiteDataStore init error: \(error)")
            }
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
            try db.run(monsterTable.drop())
            try db.run(powerUpBoxTable.drop())
            try db.run(wallTable.drop())

            // Comment out below to test for persistency
//            try db.run(twinkleStarAchievementTable.drop())
//            try db.run(stellarCollectorAchievementTable.drop())
//            try db.run(powerRangerAchievementTable.drop())
        } catch {
            print("Error deleting table \(error)")
        }
    }

    private func createAllTables() {
        createLevelTable()
        createCollectibleTable()
        createMonsterTable()
        createObstacleTable()
        createPowerUpBoxTable()
        createWallTable()
        createAchievementTables()
    }

    private func createLevelTable() {
        guard let db = db else {
            return
        }
        let id = Expression<Int64>("id")
        let name = Expression<String>("name")
        let size = Expression<String>("size")
        let background = Expression<String>("background")
        do {
            try db.run( levelTable.create { table in
                table.column(id, primaryKey: true)
                table.column(name)
                table.column(size)
                table.column(background)
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
        let radius = Expression<String>("radius")

        do {
            try db.run( collectibleTable.create { table in
                table.column(id, primaryKey: .autoincrement)
                table.column(levelId)
                table.column(position)
                table.column(points)
                table.column(radius)

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

    private func createWallTable() {
        guard let db = db else {
            return
        }
        let id = Expression<Int64>("id")
        let levelId = Expression<Int64>("levelId")
        let position = Expression<String>("position")
        let size = Expression<String>("size")

        do {
            try db.run( wallTable.create { table in
                table.column(id, primaryKey: .autoincrement)
                table.column(levelId)
                table.column(position)
                table.column(size)

            })
            print("Wall table created")
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

    private func createPowerUpBoxTable() {
        guard let db = db else {
            return
        }
        let id = Expression<Int64>("id")
        let levelId = Expression<Int64>("levelId")
        let position = Expression<String>("position")
        let size = Expression<String>("size")
        let type = Expression<String>("type")

        do {
            try db.run( powerUpBoxTable.create { table in
                table.column(id, primaryKey: .autoincrement)
                table.column(levelId)
                table.column(position)
                table.column(size)
                table.column(type)

            })
            print("PowerUpBox table created")
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
    func insertJsonData(filename: String) {
        if let fileURL = Bundle.main.url(forResource: filename, withExtension: "json") {
            // Read JSON data from the file
            do {
                let jsonData = try Data(contentsOf: fileURL)
                // Decode JSON data into LevelData
                let levelData = try JSONDecoder().decode(LevelData.self, from: jsonData)
                let levelPersistable = LevelPersistable(
                    id: levelData.id,
                    name: levelData.name,
                    size: levelData.size,
                    background: levelData.background
                )
                insert(persistable: levelPersistable)
                for persistable in levelData.collectibles {
                    insert(persistable: persistable)
                }
                for persistable in levelData.obstacles {
                    insert(persistable: persistable)
                }
                for persistable in levelData.monsters {
                    insert(persistable: persistable)
                }
                for persistable in levelData.powerUpBoxes {
                    insert(persistable: persistable)
                }
                for persistable in levelData.walls {
                    insert(persistable: persistable)
                }
                print("Inserted \(filename)")
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

    func getLevels() -> [LevelPersistable] {
        guard let database = db else {
            return []
        }
        do {
            let levels = try database.prepare(levelTable).map { row in
                let persistable: LevelPersistable = try row.decode()
                return persistable
            }
            return levels
        } catch {

        }
        return []
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
            entities += try database.prepare(obstacleTable.filter(levelId == levelIdColumn)).map { row in
                let persistable: ObstacleEntityPersistable = try row.decode()
                return persistable
            }
            entities += try database.prepare(monsterTable.filter(levelId == levelIdColumn)).map { row in
                let persistable: MonsterEntityPersistable = try row.decode()
                return persistable
            }
            entities += try database.prepare(powerUpBoxTable.filter(levelId == levelIdColumn)).map { row in
                let persistable: PowerUpBoxEntityPersistable = try row.decode()
                return persistable
            }
            entities += try database.prepare(wallTable.filter(levelId == levelIdColumn)).map { row in
                let persistable: WallEntityPersistable = try row.decode()
                return persistable
            }
        } catch {
            print("Error retriving \(error)")
        }

        return entities
    }
}
