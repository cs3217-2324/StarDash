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
            let entityPersistabls = self.database.getEntityPersistables(levelId: id)
            return Level(levelPersistable: levelPersistable, entityPersistables: entityPersistabls)
        }
        return nil
    }
}
