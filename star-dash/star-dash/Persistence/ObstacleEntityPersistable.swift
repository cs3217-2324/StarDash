//
//  ObstacleEntityPersistable.swift
//  star-dash
//
//  Created by Lau Rui han on 22/3/24.
//

import Foundation

struct ObstacleEntityPersistable: Codable, EntityPersistable {
    var levelId: Int64
    var position: CGPoint
    var sprite: String
    var size: CGSize

    func toEntity() -> Entity {
        Obstacle(position: self.position, sprite: self.sprite, size: self.size)
    }
}
