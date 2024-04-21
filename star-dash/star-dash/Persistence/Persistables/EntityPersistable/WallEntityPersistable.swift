//
//  WallEntityPersistable.swift
//  star-dash
//
//  Created by Ho Jun Hao on 13/4/24.
//

import Foundation

struct WallEntityPersistable: Codable, EntityPersistable {
    var levelId: Int64
    var position: CGPoint
    var size: CGSize

    func addTo(_ entityManager: EntityManagerInterface) {
        EntityFactory.createAndAddMonsterWall(to: entityManager, position: position, size: size)
    }
}
