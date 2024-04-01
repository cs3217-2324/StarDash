//
//  PowerRangerAchievement.swift
//  star-dash
//
//  Created by Ho Jun Hao on 31/3/24.
//

import Foundation

class PowerRangerAchievement: Achievement {
    let name: String = "Power Ranger"
    let description: String = "Use at least 3 power ups in a single game."
    let imageName: String = ""
    let playerId: EntityId

    var powerUpsUsed: Int

    init(playerId: EntityId, powerUpsUsed: Int) {
        self.playerId = playerId
        self.powerUpsUsed = powerUpsUsed
    }

    var progress: Double {
        min(1, Double(powerUpsUsed) / 3)
    }

    var isUnlocked: Bool {
        powerUpsUsed >= 3
    }

    func reset() {
        powerUpsUsed = 0
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

        powerUpsUsed += 1

        if isUnlocked {
            print("Unlocked \(name) Achievement!")
        }
    }
}
