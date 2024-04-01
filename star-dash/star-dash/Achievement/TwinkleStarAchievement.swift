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
    let imageName: String = ""
    let playerId: EntityId

    var hasCollectedStar: Bool

    init(playerId: EntityId, hasCollectedStar: Bool) {
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

        hasCollectedStar = true

        if isUnlocked {
            print("Unlocked \(name) Achievement!")
        }
    }
}
