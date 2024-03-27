//
//  MonsterEntityPersistable.swift
//  star-dash
//
//  Created by Lau Rui han on 22/3/24.
//

import Foundation

struct MonsterEntityPersistable: Codable, EntityPersistable {
    var levelId: Int64
    var position: CGPoint
    var sprite: String
    var health: Int
    var size: CGSize

    func toEntity() -> Entity {
        Monster(position: self.position, health: self.health, sprite: self.sprite, size: self.size)
    }
}
