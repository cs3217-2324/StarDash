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
        soundSystem.startBackgroundMusic()
    }

    @IBAction private func singlePlayer(_ sender: Any) {
        let numberOfPlayers = 1
        performSegue(withIdentifier: "LevelSelectSegue", sender: GameData(level: nil,
                                                                          numberOfPlayers: numberOfPlayers,
                                                                          storageManager: storageManager))
    }

    @IBAction private func localMultiplayer(_ sender: Any) {
        let numberOfPlayers = 2
        performSegue(withIdentifier: "LevelSelectSegue",
                     sender: GameData(level: nil,
                                      numberOfPlayers: numberOfPlayers,
                                      storageManager: storageManager))
    }

    @IBAction private func viewAchievements(_ sender: Any) {
        performSegue(withIdentifier: "AchievementsSegue", sender: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "LevelSelectSegue" {
            if let destinationVC = segue.destination as? LevelSelectorViewController {
                if let data = sender as? GameData {
                    destinationVC.numberOfPlayers = data.numberOfPlayers
                    destinationVC.storageManager = data.storageManager
                }
            }
        }
    }

}
