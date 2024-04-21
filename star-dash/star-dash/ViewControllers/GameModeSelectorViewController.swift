//
//  GameModeSelectorViewController.swift
//  star-dash
//
//  Created by Lau Rui han on 19/4/24.
//

import Foundation
import UIKit

class GameModeSelectorViewController: UIViewController {
    var storageManager: StorageManager?
    var numberOfPlayers: Int = 0
    var viewLayout: Int = 0
    var playerIndex: Int?
    var gameMode: GameMode?
    var networkManager: NetworkManager?
    var level: LevelPersistable?
    @IBOutlet private var selectionContainer: UIStackView!
    override func viewDidLoad() {
        super.viewDidLoad()
        if playerIndex == nil || playerIndex == 0 {
            setUp()
        } else {
            setUpWaiting()
        }
        guard let networkManager = networkManager else {
            return
        }
        networkManager.delegate = self
    }

    @IBAction private func back(_ sender: Any) {
        self.performSegue(withIdentifier: "BackSegue",
                          sender: nil)
    }
    func setUpWaiting() {
        let label = UILabel()
        label.text = "Waiting for host to select game mode"
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.textColor = .black
        selectionContainer.addArrangedSubview(label)
    }
    func setUp() {
        let button1 = createButton(imageName: "TimedMode",
                                   title: "Timed Mode",
                                   subtitle: "Collect as many points as you can in 2 mins",
                                   tag: 1)
        button1.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)

        // Create Button 2
        let button2 = createButton(imageName: "RaceMode",
                                   title: "Race mode",
                                   subtitle: "Collect as many points as possible and finish first to get extra points!",
                                   tag: 2)
        button2.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)

        // Add buttons to view
        selectionContainer.addArrangedSubview(button1)
        selectionContainer.addArrangedSubview(button2)

    }

    func createButton(imageName: String, title: String, subtitle: String, tag: Int) -> UIButton {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tag = tag

        // Set button image
        if let image = UIImage(named: imageName) {
            // Resize image to fit 200x200
            let scaledImage = image.resizeImage(CGSize(width: 200, height: 200), opaque: true)
            button.setImage(scaledImage, for: .normal)
            button.imageView?.contentMode = .scaleAspectFit
            button.imageView?.backgroundColor = .clear
            button.imageView?.translatesAutoresizingMaskIntoConstraints = false
        }

        // Set button title
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = title
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont.boldSystemFont(ofSize: 22)
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center
        button.addSubview(titleLabel)

        // Set button subtitle
        let subtitleLabel = UILabel()
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.text = subtitle
        subtitleLabel.numberOfLines = 0
        subtitleLabel.font = UIFont.systemFont(ofSize: 16)
        subtitleLabel.textColor = .black
        subtitleLabel.textAlignment = .center
        button.addSubview(subtitleLabel)

        guard let imageView = button.imageView else {
            return button
        }

        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: 200),
            button.heightAnchor.constraint(equalToConstant: 300),
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: button.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: button.trailingAnchor),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            subtitleLabel.leadingAnchor.constraint(equalTo: button.leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: button.trailingAnchor)
        ])

        return button
    }

    // Helper method to resize image while preserving aspect ratio
    @objc
    func buttonTapped(_ sender: UIButton) {
            // Handle button tap
        guard let gameModeType = GameModeType(rawValue: sender.tag) else {
            return
        }
        guard let networkManager = networkManager else {
            moveToGame(gameModeType: gameModeType)
            return
        }
        guard let playerIndex = playerIndex else {
            return
        }
        networkManager.sendEvent(event: NetworkSelectGameModeEvent(playerIndex: playerIndex, gameMode: gameModeType))
    }

    private func moveToGame(gameModeType: GameModeType) {
        guard let storageManager = storageManager,
              let level = level else {
            return
        }
        let gameMode = GameModeFactory.toGameMode(gameModeType: gameModeType)
        DispatchQueue.main.async { [self] in
            self.performSegue(withIdentifier: "MoveToGameSegue",
                              sender: GameData(level: level,
                                               numberOfPlayers: self.numberOfPlayers,
                                               viewLayout: self.viewLayout,
                                               gameMode: gameMode,
                                               storageManager: storageManager,
                                               networkManager: self.networkManager,
                                               playerIndex: self.playerIndex))
        }

    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MoveToGameSegue" {
            if let destinationVC = segue.destination as? GameViewController {
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
}

extension GameModeSelectorViewController: NetworkManagerDelegate {
    func networkManager(_ networkManager: NetworkManager, didReceiveEvent response: Data) {
        if let event = NetworkEventFactory.decodeNetworkEvent(from: response) as? NetworkSelectGameModeEvent {
            moveToGame(gameModeType: event.gameMode)
        }
    }

    func networkManager(_ networkManager: NetworkManager, didEncounterError error: Error) {
        print(error)
    }


}
