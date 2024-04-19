//
//  GameData.swift
//  star-dash
//
//  Created by Lau Rui han on 2/4/24.
//

import Foundation

struct GameData {
    let level: LevelPersistable?
    let numberOfPlayers: Int
    let viewLayout: Int
    let gameMode: GameMode
    let storageManager: StorageManager
    let networkManager: NetworkManager?
    let playerIndex: Int?
}
