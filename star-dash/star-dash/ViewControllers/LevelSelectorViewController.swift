//
//  LevelSelectorViewController.swift
//  star-dash
//
//  Created by Lau Rui han on 1/4/24.
//

import Foundation
import UIKit
class LevelSelectorViewController: UIViewController {
    var storageManager: StorageManager?
    var numberOfPlayers: Int = 0
    var viewLayout: Int = 0
    var playerIndex: Int?
    var levels: [LevelPersistable] = [] // Assuming Level is a struct or class representing a level
    var networkManager: NetworkManager?

    @IBOutlet private var levelsStackView: UIStackView!

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchLevelsFromDatabase()
        createLevelButtons()

        guard let networkManager = networkManager else {
            return
        }
        networkManager.delegate = self
    }

    private func fetchLevelsFromDatabase() {
        if let levels = storageManager?.database.getLevels() {
            self.levels = levels
        }
    }

    private func createLevelButtons() {
        for (index, level) in levels.enumerated() {
            let button = createLevelButton(name: level.name, imageName: level.background, index: index)
            levelsStackView.addArrangedSubview(button)
        }
    }

    private func moveToGame(level: LevelPersistable) {
        guard let storageManager = storageManager else {
            return
        }

        DispatchQueue.main.async { [self] in
            self.performSegue(withIdentifier: "PlaySegue",
                              sender: GameData(level: level,
                                               numberOfPlayers: self.numberOfPlayers,
                                               viewLayout: self.viewLayout,
                                               storageManager: storageManager,
                                               networkManager: self.networkManager,
                                               playerIndex: self.playerIndex))
        }

    }

    @IBAction private func back(_ sender: Any) {
        performSegue(withIdentifier: "BackSegue", sender: nil)
    }

    @objc
    func levelButtonTapped(_ sender: UIButton) {
        guard let storageManager = storageManager
               else {
            return
        }
        let level = levels[sender.tag]
        print(level)
        guard let networkManager = networkManager else {
            moveToGame(level: level)
            return
        }
        print("have network")
        guard let playerIndex = playerIndex else {
            return
        }
        let networkEvent = NetworkSelectLevelEvent(playerIndex: playerIndex, level: level)
        networkManager.sendEvent(event: networkEvent)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PlaySegue" {
            if let destinationVC = segue.destination as? GameViewController {
                if let data = sender as? GameData {
                    if let level = data.level {
                        destinationVC.level = level
                    }
                    destinationVC.viewLayout = data.viewLayout
                    destinationVC.numberOfPlayers = data.numberOfPlayers
                    destinationVC.storageManager = data.storageManager
                    destinationVC.networkManager = data.networkManager
                    destinationVC.playerIndex = data.playerIndex
                }
            }
        }
    }

    private func createLevelButton(name: String, imageName: String, index: Int) -> UIButton {
        let button = UIButton()
        var config = UIButton.Configuration.plain()
        config.attributedTitle = AttributedString(
            name,
            attributes: AttributeContainer([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 30)])
        )
        config.baseForegroundColor = .white
        config.image = UIImage(named: imageName)?.resizeImage(CGSize(width: 300, height: 200), opaque: true)
        config.imagePlacement = .top
        config.imagePadding = 10
        button.configuration = config

        button.tag = index
        button.backgroundColor = .clear
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(levelButtonTapped(_:)), for: .touchUpInside)
        return button
    }
}

extension LevelSelectorViewController: NetworkManagerDelegate {
    func networkManager(_ networkManager: NetworkManager, didReceiveEvent response: Data) {
        if let event = NetworkEventFactory.decodeNetworkEvent(from: response) as? NetworkSelectLevelEvent {
            moveToGame(level: event.level)
        }
    }

    func networkManager(_ networkManager: NetworkManager, didReceiveMessage message: String) {
        print(message)
    }

    func networkManager(_ networkManager: NetworkManager, didEncounterError error: Error) {
        print(error)
    }

    func networkManager(_ networkManager: NetworkManager, didReceiveAPIResponse response: Any) {

    }

}
