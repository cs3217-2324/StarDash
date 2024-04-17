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

    @IBOutlet var resultsModalView: UIView!
    @IBOutlet var homeButton: UIButton!
    @IBOutlet var resultsStackView: UIStackView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        populateResults()
    }

    private func setupUI() {
        resultsModalView.layer.cornerRadius = 50
    }

    private func populateResults() {
        guard let gameResults = gameResults else {
            return
        }
        for playerResult in gameResults.playerResults {
            let playerResultView = PlayerResultView.createPlayerResultView(from: playerResult)
            resultsStackView.addArrangedSubview(playerResultView)
        }
    }

    @IBAction func back(_ sender: Any) {
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
        let horizontalStackView = UIStackView()
        playerIconView.contentMode = .scaleAspectFit
        playerIconView.translatesAutoresizingMaskIntoConstraints = false
        horizontalStackView.addArrangedSubview(playerIconView)

        resultLabel.textAlignment = .center
        resultLabel.font = UIFont(name: "Futura-Medium", size: 50)
        resultLabel.translatesAutoresizingMaskIntoConstraints = false
        horizontalStackView.addArrangedSubview(resultLabel)

        addSubview(horizontalStackView)

        NSLayoutConstraint.activate([
            playerIconView.widthAnchor.constraint(equalToConstant: 30)
        ])
    }

    static func createPlayerResultView(from playerResult: PlayerResult) -> PlayerResultView {
        let playerResultView = PlayerResultView()
        let iconImage =
            SpriteConstants.playerImageIconMap[playerResult.spriteImage] ?? SpriteConstants.playerRedNoseIcon
        playerResultView.playerIconView.image = UIImage(named: iconImage)
        playerResultView.resultLabel.text = playerResult.result
        return playerResultView
    }
}
