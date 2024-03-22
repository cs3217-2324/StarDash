//
//  CollectibleEntityPersistable.swift
//  star-dash
//
//  Created by Lau Rui han on 22/3/24.
//

import Foundation
struct CollectibleEntityPersistable: Codable, EntityPersistable {

    var levelId: Int64
    var position: CGPoint
    var sprite: String
    var points: Int
    var size: CGSize
    func toEntity() -> Entity {
        Collectible(position: self.position, sprite: self.sprite, points: self.points, size: self.size)
    }
}
