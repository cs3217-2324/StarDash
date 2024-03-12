import UIKit

class ControlView: UIView {

    func setupSubviews() {
        setupMovementControls()
        setupActionControls()
    }

    private func setupMovementControls() {
        
    }

    private func setupActionControls() {
        let button = UIButton(type: .custom)
        
        let buttonSize: CGFloat = 50
        let buttonMargin: CGFloat = 20
        let buttonX = frame.width - buttonSize - buttonMargin
        let buttonY = frame.height - buttonSize - buttonMargin
        button.frame = CGRect(x: buttonX, y: buttonY, width: buttonSize, height: buttonSize)
        
        button.layer.cornerRadius = buttonSize / 2
        button.clipsToBounds = true
        
        button.backgroundColor = #colorLiteral(red: 0.968627451, green: 0.7019607843, blue: 0.1019607843, alpha: 1)
        addSubview(button)
    }
}
