//
//  ToolEntityPersistable.swift
//  star-dash
//
//  Created by Lau Rui han on 22/3/24.
//

import Foundation

struct ToolEntityPersistable: Codable, EntityPersistable {
    var levelId: Int64
    var position: CGPoint
    var size: CGSize

    func addTo(_ entityManager: EntityManagerInterface) {
        EntityFactory.createAndAddTool(to: entityManager,
                                       position: self.position,
                                       size: self.size)
    }
}
