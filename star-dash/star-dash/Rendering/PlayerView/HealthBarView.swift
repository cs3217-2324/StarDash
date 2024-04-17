import UIKit

class HealthBarView: UIView {
    private var healthBar = UIView()
    private var maxHealthBar = UIView()

    var maxHealth: CGFloat = 100.0 {
        didSet {
            setNeedsLayout()
        }
    }

    var currentHealth: CGFloat = 100.0 {
        didSet {
            updateHealthBar()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupHealthBar()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupHealthBar()
    }

    private func setupHealthBar() {
        maxHealthBar.layer.borderWidth = 2
        maxHealthBar.layer.borderColor = UIColor.green.cgColor
        addSubview(maxHealthBar)

        healthBar.backgroundColor = UIColor.green
        addSubview(healthBar)
    }

    private func updateHealthBar() {
        let healthPercentage = currentHealth / maxHealth
        let newWidth = bounds.width * healthPercentage
        healthBar.frame.size.width = newWidth
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        healthBar.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height)
        maxHealthBar.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height)
        updateHealthBar()
    }
}
