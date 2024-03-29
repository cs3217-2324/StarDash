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
    private var db: Connection?
    // Define a dictionary to map entity types to tables
    let tableMap: [ObjectIdentifier: Table]
    init() {
        tableMap = [
            ObjectIdentifier(CollectibleEntityPersistable.self): self.collectibleTable,
            ObjectIdentifier(ToolEntityPersistable.self): self.toolTable,
            ObjectIdentifier(ObstacleEntityPersistable.self): self.obstacleTable,
            ObjectIdentifier(MonsterEntityPersistable.self): self.monsterTable
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
