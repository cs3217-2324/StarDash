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
    
    private init() {
        if let docDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let dirPath = docDir.appendingPathComponent(Self.DIR_DB)

            do {
                try FileManager.default.createDirectory(
                    atPath: dirPath.path,
                    withIntermediateDirectories: true,
                    attributes: nil)
                let dbPath = dirPath.appendingPathComponent(Self.DB_NAME).path
                self.db = try Connection(dbPath)
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
        } catch {}

    }

    private func createAllTables() {
        createLevelTable()
    }

    private func createLevelTable() {
        guard let db = db else {
            return
        }
        let id = Expression<Int64>("id")
        let name = Expression<String>("name")
        do {
            try db.run( levelTable.create { table in
                table.column(id, primaryKey: .autoincrement)
                table.column(name)
            })
            print("Level table created")
        } catch {
            print("Error creating table \(error)")
        }
    }

    func addLevel() {
        
    }
}
