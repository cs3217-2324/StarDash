//
//  Level.swift
//  star-dash
//
//  Created by Lau Rui han on 21/3/24.
//

import Foundation

struct Level {
    var name: String
    var entities: [Entity]

    init(name: String, entities: [Entity]) {
        self.name = name
        self.entities = entities
    }

    init(levelPersistable: LevelPersistable, entityPersistables: [EntityPersistable]) {
        let entities = entityPersistables.compactMap { $0.toEntity() }
        self.init(name: levelPersistable.name, entities: entities)
    }
}
