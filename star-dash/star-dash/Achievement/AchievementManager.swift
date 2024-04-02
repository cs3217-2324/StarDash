//
//  AchievementManager.swift
//  star-dash
//
//  Created by Ho Jun Hao on 31/3/24.
//

import Foundation

class AchievementManager: EventListener {
    static let shared = AchievementManager()

    private var entityIdMap: [EntityId: Int] = [:]
    private var idAchievementMap: [Int: PlayerAchievements] = [:]
    private var storageManager = StorageManager()
    private var achievementFactoryMap: [ObjectIdentifier: (Int) -> Achievement] = [:]

    var eventHandlers: [ObjectIdentifier: (Event) -> Void] = [:]

    func setup() {}

    func setup(withMap entityIdMap: [EntityId: Int]) {
        self.entityIdMap = entityIdMap

        achievementFactoryMap[ObjectIdentifier(TwinkleStarAchievement.self)] = { id in
            AchievementFactory.createTwinkleStarAchievement(id)
        }

        achievementFactoryMap[ObjectIdentifier(StellarCollectorAchievement.self)] = { id in
            AchievementFactory.createStellarCollectorAchievement(id)
        }

        achievementFactoryMap[ObjectIdentifier(PowerRangerAchievement.self)] = { id in
            AchievementFactory.createPowerRangerAchievement(id)
        }

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
            var playerAchievements: [Achievement] = self.storageManager.loadAchievements(of: id)

            let typesAlreadyExisting = Set(playerAchievements.map { ObjectIdentifier(type(of: $0)) })
            let allTypes = Set(achievementFactoryMap.keys)
            let typesMissing = allTypes.subtracting(typesAlreadyExisting)

            if typesMissing.isEmpty {
                print("Loaded achievements from database")
            } else {
                print("Initialised new achievements")
            }

            for type in typesMissing {
                guard let achievement = achievementFactoryMap[type]?(id) else {

                    continue
                }
                playerAchievements.append(achievement)
            }

            idAchievementMap[id] = PlayerAchievements(playerId: id, achievements: playerAchievements)
        }

        idAchievementMap.values.forEach {
            print("+++++ achievements loaded in for \($0.playerId) ++++++")
            $0.achievements.forEach {
                print("\($0.name) Achievement: \($0.progress)")
            }
        }
    }
}
