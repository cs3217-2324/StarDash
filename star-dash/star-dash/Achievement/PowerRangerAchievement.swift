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
    let imageName: String = "PowerRanger"
    let playerId: Int

    var powerUpsUsed: Int

    init(playerId: Int, powerUpsUsed: Int = 0) {
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

    func handleEvent(event: Event, saveTo storageManager: StorageManager) {
        guard event is PowerUpBoxPlayerEvent else {
            return
        }

        guard !isUnlocked else {
            return
        }

        powerUpsUsed += 1

        if isUnlocked {
            storageManager.upsert(achievement: self)
            print("Unlocked \(name) Achievement!")
        }
    }
}
