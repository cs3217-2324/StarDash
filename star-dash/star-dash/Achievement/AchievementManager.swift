//
//  AchievementManager.swift
//  star-dash
//
//  Created by Ho Jun Hao on 31/3/24.
//

import Foundation

class AchievementManager: EventListener {
    private var entityIdMap: [EntityId: Int] = [:]
    private(set) var idAchievementMap: [Int: PlayerAchievements] = [:]
    private var storageManager = StorageManager()
    private var achievementFactoryMap: [ObjectIdentifier: (Int) -> Achievement] = [:]

    var eventHandlers: [ObjectIdentifier: (Event) -> Void] = [:]

    init() {
        setupAchievements()
    }

    init(withMap entityIdMap: [EntityId: Int]) {
        self.entityIdMap = entityIdMap
        setupAchievements(with: Array(entityIdMap.values))
    }

    func setup() {}

    func setupAchievements(with playerIds: [Int]? = nil) {
        achievementFactoryMap[ObjectIdentifier(TwinkleStarAchievement.self)] = { id in
            AchievementFactory.createTwinkleStarAchievement(id)
        }

        achievementFactoryMap[ObjectIdentifier(StellarCollectorAchievement.self)] = { id in
            AchievementFactory.createStellarCollectorAchievement(id)
        }

        achievementFactoryMap[ObjectIdentifier(PowerRangerAchievement.self)] = { id in
            AchievementFactory.createPowerRangerAchievement(id)
        }

        if let playerIds = playerIds {
            loadAchievements(playerIds: playerIds)
        } else {
            loadAchievements()
        }
    }

    func handleEvent(event: Event) {
        guard let playerEntityId = event.playerIdForEvent,
              let playerId = entityIdMap[playerEntityId],
              let playerAchievements = idAchievementMap[playerId] else {
            return
        }

        playerAchievements.achievements.forEach { $0.handleEvent(event: event, saveTo: storageManager) }
    }

    private func loadAchievements(playerIds: [Int]? = nil) {
        if let ids = playerIds {
            loadAchievementsForPlayers(ids)
        } else {
            loadAllAchievements()
        }

        idAchievementMap.values.forEach {
            print("+++++ Achievements loaded for player \($0.playerId) ++++++")
            $0.achievements.forEach {
                print("\($0.name) Achievement: \($0.progress)")
            }
        }
    }

    private func loadAchievementsForPlayers(_ playerIds: [Int]) {
        for id in playerIds {
            var playerAchievements: [Achievement] = self.storageManager.loadAchievements(of: id)
            fillMissingAchievements(playerAchievements: &playerAchievements, playerId: id)
            idAchievementMap[id] = PlayerAchievements(playerId: id, achievements: playerAchievements)
        }
    }

    private func loadAllAchievements() {
        let allPlayerAchievements: [Achievement] = self.storageManager.loadAchievements()
        let groupedAchievements = Dictionary(grouping: allPlayerAchievements, by: { $0.playerId })

        for (id, achievements) in groupedAchievements {
            var playerAchievements = achievements
            fillMissingAchievements(playerAchievements: &playerAchievements, playerId: id)
            idAchievementMap[id] = PlayerAchievements(playerId: id, achievements: playerAchievements)
        }
    }

    private func fillMissingAchievements(playerAchievements: inout [Achievement], playerId: Int) {
        let typesAlreadyExisting = Set(playerAchievements.map { ObjectIdentifier(type(of: $0)) })
        let allTypes = Set(achievementFactoryMap.keys)
        let typesMissing = allTypes.subtracting(typesAlreadyExisting)

        if typesMissing.isEmpty {
            print("Loaded achievements for player \(playerId) from database")
        } else {
            print("Initialized new achievements for player \(playerId)")
        }

        for type in typesMissing {
            guard let achievement = achievementFactoryMap[type]?(playerId) else {
                continue
            }
            playerAchievements.append(achievement)
        }
    }
}
