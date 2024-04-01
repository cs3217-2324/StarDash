//
//  AchievementManager.swift
//  star-dash
//
//  Created by Ho Jun Hao on 31/3/24.
//

import Foundation

class AchievementManager: EventListener {
    static let shared = AchievementManager()

    var entityIdMap: [EntityId: Int] = [:]
    var idAchievementMap: [Int: PlayerAchievements] = [:]
    var eventHandlers: [ObjectIdentifier: (Event) -> Void] = [:]
    var storageManager = StorageManager()

    func setup() {}

    func setup(withMap entityIdMap: [EntityId: Int]) {
        self.entityIdMap = entityIdMap
        self.idAchievementMap = storageManager.loadAchievements()
    }

    func handleEvent(event: Event) {
        // TODO: after creation of gameover event, trigger save achievements
//        if let gameoverEvent = event as? GameOverEvent else {
//            self.storageManager.saveAchievements(Array(idAchievementMap.values))
//        }
        guard let playerEntityId = event.playerIdForEvent,
              let playerId = entityIdMap[playerEntityId],
              let playerAchievements = idAchievementMap[playerId] else {
            return
        }

        playerAchievements.achievements.forEach { $0.handleEvent(event: event) }
    }
}
