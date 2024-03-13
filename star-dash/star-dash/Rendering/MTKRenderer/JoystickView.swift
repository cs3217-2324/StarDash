import UIKit

/**
 `JoystickView` is represents the joystick which the user drags with
 to move the character.
 */
class JoystickView: UIView {

    let joystickBackground: UIView
    let joystickControl: UIView

    init(frame: CGRect, buttonSize: CGFloat) {
        joystickBackground = UIImageView(image: #imageLiteral(resourceName: "JoystickBackground"))
        joystickControl = UIImageView(image: #imageLiteral(resourceName: "JoystickControl"))

        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        self.joystickBackground = UIImageView(image: #imageLiteral(resourceName: "JoystickBackground"))
        self.joystickControl = UIImageView(image: #imageLiteral(resourceName: "JoystickControl"))
        super.init(coder: coder)
    }

    func setupSubviews() {
        joystickBackground.frame = CGRect(
            x: 0, y: 0, width: frame.width, height: frame.height
        )
        joystickBackground.alpha = 0.5
        addSubview(joystickBackground)

        joystickControl.frame = CGRect(
            x: frame.width / 2 - buttonSize / 2,
            y: frame.height / 2 - buttonSize / 2,
            width: buttonSize,
            height: buttonSize
        )
        addSubview(joystickControl)
    }

    /// Translates the joystick control towards the location.
    func moveJoystick(location: CGPoint) {
        UIView.cancelPreviousPerformRequests(withTarget: joystickControl)

        if shouldSendMoveEvent(location: location) {
            // send move event
        }

        let maxX = joystickBackground.frame.width - joystickControl.frame.width / 2
        let minX = joystickControl.frame.width / 2

        joystickControl.center = CGPoint(
            x: min(max(location.x, minX), maxX),
            y: joystickControl.center.y
        )
    }

    /// Returns the joystick to its original position.
    func returnJoystick() {
        UIView.animate(withDuration: 0.8, delay: 0, options: .curveEaseOut, animations: {
            self.joystickControl.center = self.joystickBackground.center
        })
    }

    // MARK: private methods

    /// Returns true if the joystick has moved significantly enough
    /// from its original position.
    private func shouldSendMoveEvent(location: CGPoint) -> Bool {
        false
    }
}
