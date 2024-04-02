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
}
