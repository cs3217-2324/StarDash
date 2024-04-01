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
        loadAchievements(ids: Array(entityIdMap.values))
    }

    func handleEvent(event: Event) {
        guard let playerEntityId = event.playerIdForEvent,
              let playerId = entityIdMap[playerEntityId],
              let playerAchievements = idAchievementMap[playerId] else {
            return
        }

        playerAchievements.achievements.forEach { $0.handleEvent(event: event, saveTo: storageManager) }
    }

    private func loadAchievements(ids: [Int]) {
        for id in ids {
            if let playerAchievements = self.storageManager.loadAchievements(of: id) {
                print("load from database for player id \(id)")
                idAchievementMap[id] = playerAchievements
            } else {
                print("initialised new achievements for player id \(id)")
                idAchievementMap[id] = AchievementFactory.createAllDefault(for: id)
            }
        }

        idAchievementMap.values.forEach {
            print("+++++ achievements loaded in for \($0.playerId) ++++++")
            $0.achievements.forEach {
                print("\($0.name) Achievement: \($0.progress)")
            }
        }
    }
}
