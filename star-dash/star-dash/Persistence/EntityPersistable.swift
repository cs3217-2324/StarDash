//
//  EntityPersistable.swift
//  star-dash
//
//  Created by Lau Rui han on 21/3/24.
//

import Foundation

struct EntityPersistable: Codable {
    var levelId: Int64
    var entityType: EntityType
    var position: CGPoint
    static var entityMap: [EntityType: (CGPoint) -> Entity] = [
        .Monster: { position in Monster(position: position) },
        .Collectible: { position in Collectible(position: position) },
        .Obstacle: { position in Obstacle(position: position) },
        .Tool: { position in Tool(position: position) }
    ]

    func toEntity() -> Entity? {

        guard let entity = EntityPersistable.entityMap[self.entityType] else {
            return nil
        }
        return entity(self.position)
    }
}
