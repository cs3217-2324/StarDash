import UIKit

class ControlView: UIView {

    func setupSubviews() {
        setupMovementControls()
        setupActionControls()
    }

    private func setupMovementControls() {
        
    }

    private func setupActionControls() {
        let jumpButton = UIButton(type: .custom)
        
        let buttonSize: CGFloat = 50
        let buttonMargin: CGFloat = 50
        let buttonX = frame.width - buttonSize - buttonMargin
        let buttonY = frame.height - buttonSize - buttonMargin
        jumpButton.frame = CGRect(x: buttonX, y: buttonY, width: buttonSize, height: buttonSize)
        
        jumpButton.setImage(#imageLiteral(named: "JumpButton"))
        addSubview(jumpButton)
    }
}
