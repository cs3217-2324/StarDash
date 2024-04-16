//
//  ResultsModalViewController.swift
//  star-dash
//
//  Created by Jason Qiu on 16/4/24.
//

import Foundation
import UIKit

class ResultsModalViewController: UIViewController {
    @IBOutlet weak var resultsModalView: UIView!
    @IBOutlet weak var homeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        resultsModalView.layer.cornerRadius = 50
    }
    
    @IBAction func back(_ sender: Any) {
        performSegue(withIdentifier: "BackSegue", sender: nil)
    }
}

class ScoreView: UIView {
    let titleLabel = UILabel()
    let scoreLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }

    private func setupUI() {
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont(name: "Futura-Medium", size: 50)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel)

        scoreLabel.textAlignment = .center
        scoreLabel.font = UIFont(name: "Futura-Medium", size: 50)
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(scoreLabel)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            scoreLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            scoreLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
        ])
    }

    static func createScoreView(score: CGFloat) -> ScoreView {
        let scoreView = ScoreView()
        scoreView.scoreLabel.text = String(Int(score))
        return scoreView
    }
}
