//
//  MenuViewController.swift
//  star-dash
//
//  Created by Lau Rui han on 1/4/24.
//

import Foundation
import UIKit

class MenuViewController: UIViewController {
    var soundSystem: SoundSystem?
    var storageManager = StorageManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        soundSystem = SoundManager.getInstance()
        soundSystem?.startBackgroundMusic()
    }

    @IBAction private func singlePlayer(_ sender: Any) {
        let singleRaceMode = SingleRaceMode()
        performSegue(withIdentifier: "LevelSelectSegue", sender: GameData(level: nil,
                                                                          gameMode: singleRaceMode,
                                                                          storageManager: storageManager))
    }

    @IBAction private func localMultiplayer(_ sender: Any) {
        let localRaceMode = LocalRaceMode()
        performSegue(withIdentifier: "LevelSelectSegue",
                     sender: GameData(level: nil,
                                      gameMode: localRaceMode,
                                      storageManager: storageManager))
    }

    @IBAction private func viewAchievements(_ sender: Any) {
        performSegue(withIdentifier: "AchievementsSegue", sender: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "LevelSelectSegue" {
            if let destinationVC = segue.destination as? LevelSelectorViewController {
                if let data = sender as? GameData {
                    destinationVC.gameMode = data.gameMode
                    destinationVC.storageManager = data.storageManager
                }
            }
        }
    }

}
