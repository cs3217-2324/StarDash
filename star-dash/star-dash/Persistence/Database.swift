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
    private let entityTable = Table("entity")
    private var db: Connection?
    
    init() {
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
            try db.run(entityTable.drop())
        } catch {}

    }

    private func createAllTables() {
        createLevelTable()
        createEntityTable()
    }

    private func createLevelTable() {
        guard let db = db else {
            return
        }
        let id = Expression<Int64>("id")
        let name = Expression<String>("name")
        do {
            try db.run( levelTable.create { table in
                table.column(id, primaryKey: true)
                table.column(name)
            })
            print("Level table created")
        } catch {
            print("Error creating table \(error)")
        }
    }
    
    private func createEntityTable() {
        guard let db = db else {
            return
        }
        let id = Expression<Int64>("id")
        let levelId = Expression<Int64>("levelId")
        let name = Expression<String>("entityType")
        let position = Expression<String>("position")
        do {
            try db.run( entityTable.create { table in
                table.column(id, primaryKey: .autoincrement)
                table.column(levelId)
                table.column(name)
                table.column(position)

            })
            print("Entity table created")
        } catch {
            print("Error creating table \(error)")
        }
    }
    

    func insertLevelPersistable(levelPersistable: LevelPersistable) {
        guard let database = db else {
            return
        }

        do {
            let insert = try self.levelTable.insert(levelPersistable)
            try database.run(insert)
        } catch {
            print("Error saving level \(error)")
        }
    }

    func insertEntityPersistable(entityPersistable: EntityPersistable) {
        guard let database = db else {
            return
        }

        do {
            let insert = try self.entityTable.insert(entityPersistable)
            try database.run(insert)
        } catch {
            print("Error saving entity \(error)")
        }
    }
}

extension Database {
    func insertJsonData() {
        do {
            if let fileURL = Bundle.main.url(forResource: "data", withExtension: "json") {
                // Read JSON data from the file
                do {
                    let jsonData = try Data(contentsOf: fileURL)
                    // Decode JSON data into LevelData
                    let levelData = try JSONDecoder().decode(LevelData.self, from: jsonData)
                    let levelPersistable = LevelPersistable(id: levelData.id, name: levelData.name)
                    insertLevelPersistable(levelPersistable: levelPersistable)
                    for entityPersistable in levelData.entities {
                        insertEntityPersistable(entityPersistable: entityPersistable)
                    }
                } catch {
                    print("Error reading or decoding JSON: \(error)")
                }
            } else {
                print("JSON file not found.")
            }
           } catch {
              print(error)
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
                    if loadedLevel.isEmpty{
                        return nil
                    }
                    return loadedLevel[0]

                } catch {
                    print("Error fetching levels \(error)")
                    return nil
                }
    }
    
    func getEntityPersistables(levelId: Int64) -> [EntityPersistable] {
        guard let database = db else {
                    return []
                }
        let idColumn = Expression<Int64>("levelId")

                do {
                    let loadedEntity: [EntityPersistable] =
                    try database.prepare(entityTable.filter(levelId == idColumn)).map { row in
                        let persistable: EntityPersistable = try row.decode()
                        return persistable
                                        
                    }
                    
                    return loadedEntity

                } catch {
                    print("Error fetching entity \(error)")
                    return []
                }
    }
    
}
