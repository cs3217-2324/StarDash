import UIKit

/**
 `OverlayView` is responsible for displaying game information
 such as points and the minimap for the player.
 */
class OverlayView: UIView {

    let margin: CGFloat = 50

    let scoreLabel = UILabel()
    let healthLabel = UILabel()
    let healthBarView = HealthBarView()

    func setupSubviews() {
        scoreLabel.numberOfLines = 1
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.textColor = .black
        addSubview(scoreLabel)

        healthLabel.numberOfLines = 1
        healthLabel.translatesAutoresizingMaskIntoConstraints = false
        healthLabel.textColor = .black
        healthLabel.text = "Health"
        addSubview(healthLabel)

        healthBarView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(healthBarView)

        NSLayoutConstraint.activate([
            healthBarView.topAnchor.constraint(equalTo: self.topAnchor, constant: margin),
            healthBarView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -1 * margin),
            healthBarView.widthAnchor.constraint(equalToConstant: 300),
            healthBarView.heightAnchor.constraint(equalToConstant: 50)
        ])

        NSLayoutConstraint.activate([
            healthLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: margin),
            healthLabel.trailingAnchor.constraint(equalTo: healthBarView.leadingAnchor, constant: -1 * margin / 2),
            healthLabel.heightAnchor.constraint(equalToConstant: 50)
        ])

        NSLayoutConstraint.activate([
            scoreLabel.topAnchor.constraint(equalTo: healthBarView.bottomAnchor, constant: margin / 2),
            scoreLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -1 * margin),
            scoreLabel.leadingAnchor.constraint(greaterThanOrEqualTo: self.leadingAnchor, constant: margin)
        ])
        update(score: 0, health: 100)
    }

    func update(score: Int, health: Int) {
        scoreLabel.text = "Score: \(score)"
        healthBarView.currentHealth = CGFloat(health)
    }
}
