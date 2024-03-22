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


    func toEntity() -> Entity? {
        // Define a map to store the creation functions for each entity type
        var entityMap: [EntityType: () -> Entity] = [:]

        // Populate the map with creation functions for each entity type
        entityMap[.Monster] = { Monster(position: self.position) }
        entityMap[.Collectible] = { Collectible(position: self.position) }
        entityMap[.Obstacle] = { Obstacle(position: self.position) }
        entityMap[.Tool] = { Tool(position: self.position) }
        
        guard let entity = entityMap[self.entityType] else {
            return nil
        }
        return entity()
    }
}
