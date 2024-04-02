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
        performSegue(withIdentifier: "LevelSelectSeque", sender: (gameMode, numberOfPlayers, storageManager))
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "LevelSelectSeque" {
            if let destinationVC = segue.destination as? LevelSelectorViewController {
                if let data = sender as? (Int, Int, StorageManager) { // Adjust types accordingly
                    destinationVC.gameMode = data.0
                    destinationVC.numberOfPlayers = data.1
                    destinationVC.storageManager = data.2
                }
            }
        }
    }

}
