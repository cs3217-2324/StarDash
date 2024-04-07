import UIKit

/**
 `OverlayView` is responsible for displaying game information
 such as points and the minimap for the player.
 */
class OverlayView: UIView {

    let margin: CGFloat = 50

    let scoreLabel = UILabel()
    let healthLabel = UILabel()

    func setupSubviews() {
        scoreLabel.numberOfLines = 1
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.textColor = .black
        addSubview(scoreLabel)

        healthLabel.numberOfLines = 1
        healthLabel.translatesAutoresizingMaskIntoConstraints = false
        healthLabel.textColor = .black
        addSubview(healthLabel)

        NSLayoutConstraint.activate([
            scoreLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: margin),
            scoreLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -1 * margin),
            scoreLabel.leadingAnchor.constraint(greaterThanOrEqualTo: self.leadingAnchor, constant: margin)
        ])

        NSLayoutConstraint.activate([
            healthLabel.topAnchor.constraint(equalTo: scoreLabel.topAnchor, constant: margin),
            healthLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -1 * margin),
            healthLabel.leadingAnchor.constraint(greaterThanOrEqualTo: self.leadingAnchor, constant: margin)
        ])

        update(score: 0, health: 0)
    }

    func update(score: Int, health: Int) {
        scoreLabel.text = "Score: \(score)"
        healthLabel.text = "Health: \(health)"
    }
}
