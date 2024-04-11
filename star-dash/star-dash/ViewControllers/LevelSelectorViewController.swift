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
    @IBOutlet private var Levels: UIStackView!

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
            let button = LevelButton()
            button.tag = index
            button.levelNameLabel.text = "\(level.name)"
            button.levelImageView.image = UIImage(named: level.background)
            button.backgroundColor = .clear
            button.layer.cornerRadius = 8
            button.addTarget(self, action: #selector(levelButtonTapped(_:)), for: .touchUpInside)
            Levels.addArrangedSubview(button)
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
        let networkEvent = NetworkSelectLevelEvent(playerIndex: playerIndex , level: level)
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
}

class LevelButton: UIButton {
    let levelImageView = UIImageView()
    let levelNameLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }

    private func setupUI() {
        // Set up image view
        levelImageView.contentMode = .scaleAspectFit
        levelImageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(levelImageView)

        // Set up label
        levelNameLabel.textAlignment = .center
        levelNameLabel.textColor = .white
        levelNameLabel.font = .boldSystemFont(ofSize: 20)
        levelNameLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(levelNameLabel)

        // Add constraints
        NSLayoutConstraint.activate([
            levelImageView.topAnchor.constraint(equalTo: topAnchor),
            levelImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            levelImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            levelImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.7),

            levelNameLabel.topAnchor.constraint(equalTo: levelImageView.bottomAnchor),
            levelNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            levelNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            levelNameLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}


extension LevelSelectorViewController: NetworkManagerDelegate {
    func networkManager(_ networkManager: NetworkManager, didReceiveEvent response: Data) {
        if let event = decodeNetworkEvent(from: response) as? NetworkSelectLevelEvent {
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
