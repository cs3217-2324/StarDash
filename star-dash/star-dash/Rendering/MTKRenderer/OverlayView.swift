import UIKit

class OverlayView: UIView {

    let margin: CGFloat = 50

    let scoreLabel: UILabel = UILabel()

    func setupSubviews() {
        scoreLabel.text = "Score: 0"
        scoreLabel.numberOfLines = 1
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(scoreLabel)

        NSLayoutConstraint.activate([
            scoreLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: margin),
            scoreLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -1 * margin),
            scoreLabel.leadingAnchor.constraint(greaterThanOrEqualTo: self.leadingAnchor, constant: margin)
        ])
    }
}
