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
    var gameMode: GameMode?
    var levels: [LevelPersistable] = [] // Assuming Level is a struct or class representing a level

    @IBOutlet private var levelsStackView: UIStackView!

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
            let button = createLevelButton(name: level.name, imageName: level.background, index: index)
            levelsStackView.addArrangedSubview(button)
        }
    }

    @IBAction private func back(_ sender: Any) {
        performSegue(withIdentifier: "BackSegue", sender: nil)
    }

    @objc
    func levelButtonTapped(_ sender: UIButton) {
        guard let storageManager = storageManager,
              let gameMode = gameMode else {
            return
        }
        let level = levels[sender.tag]
        performSegue(withIdentifier: "PlaySegue",
                     sender: GameData(level: level,
                                      gameMode: gameMode,
                                      storageManager: storageManager))
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PlaySegue" {
            if let destinationVC = segue.destination as? GameViewController {
                if let data = sender as? GameData {
                    if let level = data.level {
                        destinationVC.level = level
                    }
                    destinationVC.gameMode = data.gameMode
                    destinationVC.storageManager = data.storageManager
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
