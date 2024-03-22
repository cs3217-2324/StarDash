//
//  EntityType.swift
//  star-dash
//
//  Created by Lau Rui han on 21/3/24.
//

import Foundation
enum EntityType: String, Encodable, Decodable {
    case Monster = "monster"
    case Collectible = "collectible"
    case Obstacle = "obstacle"
    case Tool = "tool"
}
