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
        for playerResult in sortedPlayerResults {
            let playerResultView = PlayerResultView.createPlayerResultView(from: playerResult)
            resultsStackView.addArrangedSubview(playerResultView)
        }
    }

    @IBAction private func back(_ sender: Any) {
        performSegue(withIdentifier: "BackSegue", sender: nil)
    }
}

class PlayerResultView: UIView {
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
        playerIconView.contentMode = .scaleAspectFit
        playerIconView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(playerIconView)

        resultLabel.textAlignment = .center
        resultLabel.font = UIFont(name: "Futura-Medium", size: 50)
        resultLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(resultLabel)

        NSLayoutConstraint.activate([
            playerIconView.widthAnchor.constraint(equalToConstant: 50),
            playerIconView.heightAnchor.constraint(equalToConstant: 50),
            playerIconView.centerYAnchor.constraint(equalTo: centerYAnchor),
            playerIconView.leadingAnchor.constraint(equalTo: leadingAnchor),

            resultLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            resultLabel.leadingAnchor.constraint(equalTo: playerIconView.trailingAnchor, constant: 20),
            resultLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }

    static func createPlayerResultView(from playerResult: PlayerResult) -> PlayerResultView {
        let playerResultView = PlayerResultView()
        let iconImage =
            SpriteConstants.playerImageIconMap[playerResult.spriteImage] ?? SpriteConstants.playerRedNoseIcon
        playerResultView.playerIconView.image = UIImage(named: iconImage)
        playerResultView.resultLabel.text = String(Int(playerResult.result))
        return playerResultView
    }
}
