//
//  LevelPersistable.swift
//  star-dash
//
//  Created by Lau Rui han on 21/3/24.
//

import Foundation
struct LevelPersistable: Encodable, Decodable {
    var id: Int64
    var name: String
    init(id: Int64, name: String) {
        self.id = id
        self.name = name
    }

}
