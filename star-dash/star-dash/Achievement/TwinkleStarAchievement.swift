//
//  FinisherAchievement.swift
//  star-dash
//
//  Created by Ho Jun Hao on 31/3/24.
//

import Foundation

class TwinkleStarAchievement: Achievement {
    let name: String = "Twinkle Star"
    let description: String = "Collect your first star."
    let imageName: String = "TwinkleStar"
    let playerId: Int

    var hasCollectedStar: Bool

    init(playerId: Int, hasCollectedStar: Bool = false) {
        self.playerId = playerId
        self.hasCollectedStar = hasCollectedStar
    }

    var progress: Double {
        hasCollectedStar ? 1 : 0
    }

    var isUnlocked: Bool {
        hasCollectedStar
    }

    func reset() {
        hasCollectedStar = false
    }

    func handleEvent(event: Event, saveTo storageManager: StorageManager) {
        guard event is PickupCollectibleEvent else {
            return
        }

        guard !isUnlocked else {
            return
        }

        hasCollectedStar = true

        storageManager.upsert(achievement: self)

        if isUnlocked {
            print("Unlocked \(name) Achievement!")
        }
    }
}
