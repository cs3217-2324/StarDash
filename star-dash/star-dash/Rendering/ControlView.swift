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

        jumpButton.addTarget(self, action: #selector(jumpButtonTapped), for: .touchUpInside)

        jumpButton.setImage(#imageLiteral(named: "JumpButton"), for: .normal)
        jumpButton.setImage(#imageLiteral(named: "JumpButtonDown"), for: .highlighted)
        addSubview(jumpButton)
    }

    func jumpButtonTapped() {
        print("Tapped")
    }
}
