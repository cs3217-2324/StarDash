//
//  Util.swift
//  star-dashTests
//
//  Created by Lau Rui han on 18/3/24.
//

import Foundation
@testable import star_dash

func createPlayerEntity() -> Player {
    Player(id: UUID())
}

func createEntityManager() -> EntityManager {
    EntityManager()
}

func createTextureSet() -> TextureSet {
    TextureSet(run: "", runLeft: "", death: "")
}
