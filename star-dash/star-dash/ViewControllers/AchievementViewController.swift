//
//  AchievementViewController.swift
//  star-dash
//
//  Created by Ho Jun Hao on 4/4/24.
//

import Foundation
import UIKit

class AchievementViewController: UIViewController {
    var achievementManager: AchievementManager?
    @IBOutlet private var playersStackView: UIStackView!

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchAchievementsFromDatabase()
        createPlayerAchievementViews()
    }

    func fetchAchievementsFromDatabase() {
        self.achievementManager = AchievementManager()
    }

    func createPlayerAchievementViews() {
        guard let achievementManager = achievementManager else {
            return
        }
        for (playerId, playerAchievements) in achievementManager.idAchievementMap {
            let playerView = PlayerAchievementView()
            playerView.playerNameLabel.text = "Player \(playerId)"
            for achievement in playerAchievements.achievements {
                let achievementView = AchievementView()
                achievementView.titleLabel.text = achievement.name
                achievementView.descriptionLabel.text = achievement.description
                achievementView.imageView.image = UIImage(named: achievement.imageName)
                playerView.achievementsStackView.addArrangedSubview(achievementView)
            }
            playersStackView.addArrangedSubview(playerView)
        }
    }

    @IBAction private func back(_ sender: Any) {
        performSegue(withIdentifier: "BackSegue", sender: nil)
    }
}

class PlayerAchievementView: UIView {
    let playerNameLabel = UILabel()
    let achievementsStackView = UIStackView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }

    private func setupUI() {
        // Set up player name label
        playerNameLabel.textAlignment = .center
        playerNameLabel.font = .boldSystemFont(ofSize: 20)
        playerNameLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(playerNameLabel)

        // Set up achievements stack view
        achievementsStackView.axis = .vertical
        achievementsStackView.spacing = 8
        achievementsStackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(achievementsStackView)

        // Add constraints
        NSLayoutConstraint.activate([
            playerNameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            playerNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            playerNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),

            achievementsStackView.topAnchor.constraint(equalTo: playerNameLabel.bottomAnchor, constant: 8),
            achievementsStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            achievementsStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            achievementsStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ])
    }
}

class AchievementView: UIView {
    let titleLabel = UILabel()
    let descriptionLabel = UILabel()
    let imageView = UIImageView()

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
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageView)

        // Set up title label
        titleLabel.textAlignment = .center
        titleLabel.font = .boldSystemFont(ofSize: 16)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel)

        // Set up description label
        descriptionLabel.textAlignment = .center
        descriptionLabel.font = .systemFont(ofSize: 14)
        descriptionLabel.numberOfLines = 0
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(descriptionLabel)

        // Add constraints
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 50),
            imageView.heightAnchor.constraint(equalToConstant: 50),

            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),

            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            descriptionLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ])
    }
}
