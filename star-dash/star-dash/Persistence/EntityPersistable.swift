//
//  EntityPersistable.swift
//  star-dash
//
//  Created by Lau Rui han on 21/3/24.
//

import Foundation

struct EntityPersistable: Encodable, Decodable {
    var levelId: Int64
    var entityType: EntityType
    var position: CGPoint

    init(levelId: Int64, entityType: EntityType, position: CGPoint) {
        self.levelId = levelId
        self.entityType = entityType
        self.position = position
    }

    func toEntity() -> Entity {
        switch entityType {
        case .Monster:
            return Monster(position: self.position)
        case .Collectible:
            return Collectible(position: self.position)
        case .Obstacle:
            return Obstacle(position: self.position)
        case .Tool:
            return Tool(position: self.position)
        }
    }
}
