//
//  ResultsModalViewController.swift
//  star-dash
//
//  Created by Jason Qiu on 16/4/24.
//

import Foundation
import UIKit

class ResultsModalViewController: UIViewController {
    var gameResults: GameResults?

    @IBOutlet private var resultsModalView: UIView!
    @IBOutlet private var homeButton: UIButton!
    @IBOutlet private var resultsStackView: UIStackView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        populateResults()
    }

    private func setupUI() {
        resultsModalView.layer.cornerRadius = 20
    }

    private func populateResults() {
        guard let gameResults = gameResults else {
            return
        }
        let sortedPlayerResults = gameResults.playerResults.sorted(by: { $0.result >= $1.result })
        for (i, playerResult) in sortedPlayerResults.enumerated() {
            let playerResultView = PlayerResultView.createPlayerResultView(from: playerResult, withRanking: i + 1)
            resultsStackView.addArrangedSubview(playerResultView)
        }
    }

    @IBAction private func back(_ sender: Any) {
        performSegue(withIdentifier: "BackSegue", sender: nil)
    }
}

class PlayerResultView: UIView {
    private var rankingLabel = UILabel()
    private var playerIconView = UIImageView()
    private var resultLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }

    private func setupUI() {
        rankingLabel.textAlignment = .center
        rankingLabel.font = UIFont(name: "Futura-Medium", size: 50)
        rankingLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(rankingLabel)

        playerIconView.contentMode = .scaleAspectFit
        playerIconView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(playerIconView)

        resultLabel.textAlignment = .center
        resultLabel.font = UIFont(name: "Futura-Medium", size: 50)
        resultLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(resultLabel)

        NSLayoutConstraint.activate([
            rankingLabel.widthAnchor.constraint(equalToConstant: 75),
            rankingLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            rankingLabel.leadingAnchor.constraint(equalTo: leadingAnchor),

            playerIconView.widthAnchor.constraint(equalToConstant: 50),
            playerIconView.heightAnchor.constraint(equalToConstant: 50),
            playerIconView.centerYAnchor.constraint(equalTo: centerYAnchor),
            playerIconView.leadingAnchor.constraint(equalTo: rankingLabel.trailingAnchor, constant: 10),

            resultLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            resultLabel.leadingAnchor.constraint(equalTo: playerIconView.trailingAnchor, constant: 10),
            resultLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }

    static func createPlayerResultView(from playerResult: PlayerResult, withRanking rank: Int) -> PlayerResultView {
        let playerResultView = PlayerResultView()
        let iconImage =
            SpriteConstants.playerImageIconMap[playerResult.spriteImage] ?? SpriteConstants.playerRedNoseIcon
        playerResultView.rankingLabel.text = "#" + String(rank)
        playerResultView.playerIconView.image = UIImage(named: iconImage)
        playerResultView.resultLabel.text = String(Int(playerResult.result))
        return playerResultView
    }
}
