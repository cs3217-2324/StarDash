import UIKit

class HealthBarView: UIView {
    private var healthBar: UIView = UIView()
    
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
    
    private func setupHealthBar() {
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
        updateHealthBar()
    }
}