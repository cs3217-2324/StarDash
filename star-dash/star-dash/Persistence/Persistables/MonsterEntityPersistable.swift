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
    var health: Int
    var size: CGSize

    func addTo(_ entityManager: EntityManagerInterface) {
        EntityFactory.createAndAddMonster(to: entityManager,
                                          position: self.position,
                                          health: self.health,
                                          size: self.size)
    }
}
