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
        let buttonX = view.frame.width - buttonSize - buttonMargin
        let buttonY = view.frame.height - buttonSize - buttonMargin
        button.frame = CGRect(x: buttonX, y: buttonY, width: buttonSize, height: buttonSize)
        
        button.layer.cornerRadius = buttonSize / 2
        button.clipsToBounds = true
        
        button.backgroundColor = #colorLiteral(red: 243, green: 157, red: 8, alpha: 1)
    }
}