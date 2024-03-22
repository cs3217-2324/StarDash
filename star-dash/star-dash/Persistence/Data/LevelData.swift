//
//  LevelData.swift
//  star-dash
//
//  Created by Lau Rui han on 22/3/24.
//

import Foundation

struct LevelData: Codable {
    var id: Int64
    var name: String
    var entities: [EntityPersistable]
    var size: CGSize

}
