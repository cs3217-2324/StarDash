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
    var gameMode: GameMode?
    var levels: [LevelPersistable] = []

    @IBOutlet private var levelScrollView: UIScrollView!
    var networkManager: NetworkManager?

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchLevelsFromDatabase()

        if playerIndex == nil || playerIndex == 0 {
            createLevelButtons()
        } else {
            createWaitingText()
        }
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
        var previous: UIView?
        levelScrollView.translatesAutoresizingMaskIntoConstraints = true

        for (index, level) in levels.enumerated() {
            let button = createLevelButton(name: level.name, imageName: level.background, index: index)

            levelScrollView.addSubview(button)
            button.translatesAutoresizingMaskIntoConstraints = false

            button.widthAnchor.constraint(equalToConstant: 300).isActive = true
            button.heightAnchor.constraint(equalToConstant: 300).isActive = true
            button.topAnchor.constraint(equalTo: levelScrollView.topAnchor).isActive = true
            button.bottomAnchor.constraint(equalTo: levelScrollView.bottomAnchor).isActive = true
            if let previous = previous {
                button.leadingAnchor.constraint(equalTo: previous.trailingAnchor, constant: 20).isActive = true
            } else {
                button.leadingAnchor.constraint(equalTo: levelScrollView.leadingAnchor, constant: 20).isActive = true
            }
            previous = button

        }
        levelScrollView.isScrollEnabled = true
        levelScrollView.contentSize = CGSize(width: 400, height: 500)
    }

    private func createWaitingText() {
        let label = UILabel()
        label.text = "Waiting for host to select a level"
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.textColor = .black
        levelsStackView.addArrangedSubview(label)
    }

    private func moveToGameModeSelect(level: LevelPersistable) {
        guard let storageManager = storageManager else {
            return
        }

        DispatchQueue.main.async { [self] in
            self.performSegue(withIdentifier: "MoveToModeSelectSegue",
                              sender: GameData(level: level,
                                               numberOfPlayers: self.numberOfPlayers,
                                               viewLayout: self.viewLayout,
                                               gameMode: nil,
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
        guard storageManager != nil
               else {
            return
        }
        let level = levels[sender.tag]
        print(level)
        guard let networkManager = networkManager else {
            moveToGameModeSelect(level: level)
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
        if segue.identifier == "MoveToModeSelectSegue" {
            if let destinationVC = segue.destination as? GameModeSelectorViewController {
                if let data = sender as? GameData {
                    if let level = data.level {
                        destinationVC.level = level
                    }
                    destinationVC.viewLayout = data.viewLayout
                    destinationVC.numberOfPlayers = data.numberOfPlayers
                    destinationVC.gameMode = data.gameMode
                    destinationVC.storageManager = data.storageManager
                    destinationVC.networkManager = data.networkManager
                    destinationVC.playerIndex = data.playerIndex
                }
            }
        }
    }

    private func createLevelButton(name: String, imageName: String, index: Int) -> UIButton {
        let button = UIButton()

        // Create image view
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: imageName)?.resizeImage(CGSize(width: 300, height: 200), opaque: true)
        imageView.translatesAutoresizingMaskIntoConstraints = false

        // Add image view to button
        button.addSubview(imageView)

        // Add constraints for image view
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: button.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: button.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: button.trailingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 200) // Adjust height as needed
        ])

        // Create label for title
        let titleLabel = UILabel()
        titleLabel.text = name
        titleLabel.font = UIFont.boldSystemFont(ofSize: 30)
        titleLabel.textAlignment = .center
        titleLabel.textColor = .white
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        // Add label to button
        button.addSubview(titleLabel)

        // Add constraints for label
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: button.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: button.trailingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: button.bottomAnchor)
        ])

        // Other button customization
        button.backgroundColor = .clear
        button.layer.cornerRadius = 8
        button.tag = index
        button.addTarget(self, action: #selector(levelButtonTapped(_:)), for: .touchUpInside)

        return button
    }

}

extension LevelSelectorViewController: NetworkManagerDelegate {
    func networkManager(_ networkManager: NetworkManager, didReceiveEvent response: Data) {
        if let event = NetworkEventFactory.decodeNetworkEvent(from: response) as? NetworkSelectLevelEvent {
            moveToGameModeSelect(level: event.level)
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
