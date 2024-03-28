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
    var points: Int
    var size: CGSize

    func addTo(_ entityManager: EntityManagerInterface) {
        EntityFactory.createAndAddCollectible(to: entityManager,
                                              position: self.position,
                                              points: self.points,
                                              size: self.size)
    }
}
