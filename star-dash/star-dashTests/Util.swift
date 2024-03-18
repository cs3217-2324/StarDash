//
//  Util.swift
//  star-dashTests
//
//  Created by Lau Rui han on 18/3/24.
//

import Foundation
@testable import star_dash

func createPlayerEntity() -> Player {
    Player(position: CGPoint(x: 0, y: 0), playerSprite: .RedNose)
}

func createEntityManager() -> EntityManager {
    EntityManager()
}
