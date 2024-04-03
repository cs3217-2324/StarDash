//
//  GameData.swift
//  star-dash
//
//  Created by Lau Rui han on 2/4/24.
//

import Foundation
struct GameData {
    let gameMode: Int
    let level: LevelPersistable?
    let numberOfPlayers: Int
    let storageManager: StorageManager
}
