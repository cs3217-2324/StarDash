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
    let playerId: EntityId

    var starsCollected: Int

    init(playerId: EntityId, starsCollected: Int) {
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

    func handleEvent(event: Event) {
        guard let collectibleEvent = event as? PickupCollectibleEvent else {
            return
        }

        guard collectibleEvent.playerId == playerId else {
            return
        }

        guard !isUnlocked else {
            return
        }

        starsCollected += 1

        if isUnlocked {
            print("Unlocked \(name) Achievement!")
        }
    }
}
