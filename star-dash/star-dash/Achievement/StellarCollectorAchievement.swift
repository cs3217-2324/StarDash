//
//  StellarCollectorAchievement.swift
//  star-dash
//
//  Created by Ho Jun Hao on 31/3/24.
//

import Foundation

class StellarCollectorAchievement: Achievement {
    let name: String = "Stellar Collector"
    let description: String = "Collect 10 Stars."
    let imageName: String = ""
    let playerId: Int

    var starsCollected: Int

    init(playerId: Int, starsCollected: Int = 0) {
        self.playerId = playerId
        self.starsCollected = starsCollected
    }

    var progress: Double {
        min(1, Double(starsCollected) / 10)
    }

    var isUnlocked: Bool {
        starsCollected >= 10
    }

    func reset() {
        starsCollected = 0
    }

    func handleEvent(event: Event, saveTo storageManager: StorageManager) {
        guard event is PickupCollectibleEvent else {
            return
        }

        guard !isUnlocked else {
            return
        }

        starsCollected += 1

        storageManager.upsert(achievement: self)

        if isUnlocked {
            print("Unlocked \(name) Achievement!")
        }
    }
}
