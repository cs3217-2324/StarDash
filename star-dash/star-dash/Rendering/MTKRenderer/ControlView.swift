import UIKit

/**
 `ControlView` is responsible for displaying the controls
 such as jump button and joystick.
 */
class ControlView: UIView {

    var joystickView: JoystickView?

    let buttonMargin: CGFloat = 50
    let buttonSize: CGFloat = 100
    let joystickBackgroundWidth: CGFloat = 256
    let panThreshold: CGFloat = 15

    var controlViewDelegate: ControlViewDelegate?

    func setupSubviews() {
        setupMovementControls()
        setupActionControls()
        setupGestureRecognizers()
    }

    // MARK: Private methods for setup

    private func setupMovementControls() {
        let joystickY = frame.height - buttonSize - buttonMargin
        let joystickView = JoystickView(frame: CGRect(
            x: buttonMargin,
            y: joystickY,
            width: joystickBackgroundWidth,
            height: buttonSize
        ))
        joystickView.setupSubviews()

        addSubview(joystickView)
        self.joystickView = joystickView
    }

    private func setupActionControls() {
        let jumpButton = UIButton(type: .custom)

        let buttonX = frame.width - buttonSize - buttonMargin
        let buttonY = frame.height - buttonSize - buttonMargin
        jumpButton.frame = CGRect(x: buttonX, y: buttonY, width: buttonSize, height: buttonSize)

        jumpButton.addTarget(self, action: #selector(jumpButtonTapped), for: .touchUpInside)

        jumpButton.setImage(#imageLiteral(resourceName: "JumpButton"), for: .normal)
        jumpButton.setImage(#imageLiteral(resourceName: "JumpButtonDown"), for: .highlighted)
        addSubview(jumpButton)
    }

    private func setupGestureRecognizers() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        addGestureRecognizer(panGesture)
    }

    // MARK: Gesture handler methods

    @objc func jumpButtonTapped() {
        controlViewDelegate?.jumpButtonPressed()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)

        guard let firstTouch = touches.first,
              firstTouch.location(in: self).x < self.frame.width / 2,
              touches.count == 1 else {
            return
        }

        joystickView?.moveJoystick(location: firstTouch.location(in: joystickView))
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)

        guard let firstTouch = touches.first?.location(in: self),
              firstTouch.x < self.frame.width / 2 else {
            return
        }

        joystickView?.returnJoystick()
    }

    @objc func handlePan(_ gesture: UIPanGestureRecognizer) {
        guard let joystickView = self.joystickView else {
            return
        }

        let location = gesture.location(in: self)
        if gesture.state == .ended {
            joystickView.returnJoystick()
        } else if location.x < self.frame.width / 2 {
            joystickView.moveJoystick(location: gesture.location(in: joystickView))

            if shouldSendMoveEvent(location: location) {
                let isLeft = gesture.location(in: joystickView).x < joystickView.center.x
                controlViewDelegate?.joystickMoved(toLeft: isLeft)
            }
        }
    }

    private func shouldSendMoveEvent(location: CGPoint) -> Bool {
        true
    }
}
