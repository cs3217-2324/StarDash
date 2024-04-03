//
//  MenuViewController.swift
//  star-dash
//
//  Created by Lau Rui han on 1/4/24.
//

import Foundation
import UIKit

class MenuViewController: UIViewController {
    var storageManager = StorageManager()
    @IBAction private func singlePlayer(_ sender: Any) {
        let gameMode = 1
        let numberOfPlayers = 1
        performSegue(withIdentifier: "LevelSelectSeque", sender: (gameMode, numberOfPlayers, storageManager))
    }
    @IBAction private func localMultiplayer(_ sender: Any) {
        let gameMode = 2
        let numberOfPlayers = 2
        performSegue(withIdentifier: "LevelSelectSeque",
                     sender: GameData(gameMode: gameMode,
                                      level: nil,
                                      numberOfPlayers: numberOfPlayers,
                                      storageManager: storageManager))
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "LevelSelectSeque" {
            if let destinationVC = segue.destination as? LevelSelectorViewController {
                if let data = sender as? GameData {
                    destinationVC.gameMode = data.gameMode
                    destinationVC.numberOfPlayers = data.numberOfPlayers
                    destinationVC.storageManager = data.storageManager
                }
            }
        }
    }

}
