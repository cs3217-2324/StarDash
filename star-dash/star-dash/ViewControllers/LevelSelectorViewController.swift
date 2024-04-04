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
    var gameMode: Int = 0
    var numberOfPlayers: Int = 0
    var levels: [LevelPersistable] = [] // Assuming Level is a struct or class representing a level

    @IBOutlet private var Levels: UIStackView!

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchLevelsFromDatabase()
        createLevelButtons()
    }

    private func fetchLevelsFromDatabase() {
        if let levels = storageManager?.database.getLevels() {
            self.levels = levels
        }
    }

    private func createLevelButtons() {
        for (index, level) in levels.enumerated() {
            let button = LevelButton()
            button.tag = index // Set a tag to identify the button later
            button.levelNameLabel.text = "\(level.name)"
            button.levelImageView.image = UIImage(named: level.background) // Set your image here
            button.backgroundColor = .clear
            button.layer.cornerRadius = 8
            button.addTarget(self, action: #selector(levelButtonTapped(_:)), for: .touchUpInside)
            Levels.addArrangedSubview(button)
        }
    }

    @IBAction private func back(_ sender: Any) {
        performSegue(withIdentifier: "BackSegue", sender: nil)
    }

    @objc
    func levelButtonTapped(_ sender: UIButton) {
        guard let storageManager = storageManager else {
            return
        }
        let level = levels[sender.tag]
        // Perform actions related to the selected level
        performSegue(withIdentifier: "PlaySegue",
                     sender: GameData(gameMode: gameMode,
                                      level: level,
                                      numberOfPlayers: numberOfPlayers,
                                      storageManager: storageManager))
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PlaySegue" {
            if let destinationVC = segue.destination as? ViewController {
                if let data = sender as? GameData { // Adjust types accordingly
                    destinationVC.gameMode = data.gameMode
                    if let level = data.level {
                        destinationVC.level = level

                    }
                    destinationVC.numberOfPlayers = data.numberOfPlayers
                    destinationVC.storageManager = data.storageManager
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
