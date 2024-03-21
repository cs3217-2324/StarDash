import UIKit

/**
 `OverlayView` is responsible for displaying game information
 such as points and the minimap for the player.
 */
class OverlayView: UIView {

    let margin: CGFloat = 50

    let scoreLabel = UILabel()

    func setupSubviews() {
        scoreLabel.text = "Score: 0"
        scoreLabel.numberOfLines = 1
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.textColor = .black
        addSubview(scoreLabel)

        NSLayoutConstraint.activate([
            scoreLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: margin),
            scoreLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -1 * margin),
            scoreLabel.leadingAnchor.constraint(greaterThanOrEqualTo: self.leadingAnchor, constant: margin)
        ])
    }

    func update(score: Int) {
        scoreLabel.text = "Score: \(score)"
    }
}
