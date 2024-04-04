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

        if achievementManager.idAchievementMap.isEmpty {
            let noAchievementsLabel = UILabel()
            noAchievementsLabel.text = "No achievement records"
            noAchievementsLabel.textAlignment = .center
            noAchievementsLabel.font = .boldSystemFont(ofSize: 20)
            noAchievementsLabel.translatesAutoresizingMaskIntoConstraints = false
            playersStackView.addArrangedSubview(noAchievementsLabel)
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
                achievementView.progressLabel.text = "Progress: \(achievement.progress)"
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
    let achievementsScrollView = UIScrollView()
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

        // Set up achievements scroll view
        achievementsScrollView.translatesAutoresizingMaskIntoConstraints = false
        achievementsScrollView.showsHorizontalScrollIndicator = false
        addSubview(achievementsScrollView)

        // Set up achievements stack view
        achievementsStackView.axis = .horizontal
        achievementsStackView.distribution = .fillEqually
        achievementsStackView.spacing = 8
        achievementsStackView.translatesAutoresizingMaskIntoConstraints = false
        achievementsScrollView.addSubview(achievementsStackView)

        // Add background color
        backgroundColor = .white.withAlphaComponent(0.5)

        // Add rounded corners
        layer.cornerRadius = 10

        // Add constraints
        NSLayoutConstraint.activate([
            playerNameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            playerNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            playerNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),

            achievementsScrollView.topAnchor.constraint(equalTo: playerNameLabel.bottomAnchor, constant: 8),
            achievementsScrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            achievementsScrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            achievementsScrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            achievementsScrollView.heightAnchor.constraint(equalTo: heightAnchor, constant: -50),

            achievementsStackView.topAnchor.constraint(equalTo: achievementsScrollView.topAnchor),
            achievementsStackView.leadingAnchor.constraint(equalTo: achievementsScrollView.leadingAnchor, constant: 8),
            achievementsStackView.trailingAnchor.constraint(equalTo: achievementsScrollView.trailingAnchor,
                                                            constant: -8),
            achievementsStackView.bottomAnchor.constraint(equalTo: achievementsScrollView.bottomAnchor),
            achievementsStackView.heightAnchor.constraint(equalTo: achievementsScrollView.heightAnchor, constant: -8)
        ])
    }
}

class AchievementView: UIView {
    let titleLabel = UILabel()
    let descriptionLabel = UILabel()
    let imageView = UIImageView()
    let progressLabel = UILabel()

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

        // Set up progress label
        progressLabel.textAlignment = .center
        progressLabel.font = .systemFont(ofSize: 12)
        progressLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(progressLabel)

        // Add background color
        backgroundColor = .white

        // Add rounded corners
        layer.cornerRadius = 10

        // Add constraints
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 150),
            imageView.heightAnchor.constraint(equalToConstant: 150),

            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),

            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),

            progressLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 4),
            progressLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            progressLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            progressLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ])
    }
}
