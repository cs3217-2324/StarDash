//
//  LevelData.swift
//  star-dash
//
//  Created by Lau Rui han on 22/3/24.
//

import Foundation

struct LevelData: Encodable, Decodable {
    var id: Int64
    var name: String
    var entities: [EntityPersistable]

    init(id: Int64, name: String, entities: [EntityPersistable]) {
        self.id = id
        self.name = name
        self.entities = entities
    }

}
