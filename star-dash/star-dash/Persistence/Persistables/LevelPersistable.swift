//
//  LevelPersistable.swift
//  star-dash
//
//  Created by Lau Rui han on 21/3/24.
//

import Foundation

struct LevelPersistable: Codable {
    var id: Int64
    var name: String
    var size: CGSize
    var background: String
}
