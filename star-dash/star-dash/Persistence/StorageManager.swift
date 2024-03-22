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

    func getLevel(id: Int64) -> Level? {
        if let levelPersistable = self.database.getLevelPersistable(id: id) {
            let entityPersistables = self.database.getAllEntities(levelId: id)
            return Level(levelPersistable: levelPersistable, entityPersistables: entityPersistables)
        }
        return nil
    }
}
