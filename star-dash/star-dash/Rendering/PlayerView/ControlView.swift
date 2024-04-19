import UIKit

/**
 `ControlView` is responsible for displaying the controls
 such as jump button and joystick.
 */
class ControlView: UIView, UIGestureRecognizerDelegate {

    var joystickView: JoystickView?

    let buttonMargin: CGFloat = 50
    let buttonSize: CGFloat = 100
    let joystickBackgroundWidth: CGFloat = 256
    let panThreshold: CGFloat = 15
    private var longPressTimer: Timer?
    var controlViewDelegate: ControlViewDelegate?
    var jumpButton: UIButton?
    var hookButton: UIButton?
    func setupSubviews() {
        setupMovementControls()
        setupActionControls()
        setupGestureRecognizers()
    }

    // MARK: Private methods for setup

    private func setupMovementControls() {
        let joystickY = bounds.height - buttonSize - buttonMargin
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
        // Jump Button
        let jumpButton = UIButton(type: .custom)
        let buttonX = bounds.width - buttonSize - buttonMargin
        let buttonY = bounds.height - buttonSize - buttonMargin
        jumpButton.frame = CGRect(x: buttonX, y: buttonY, width: buttonSize, height: buttonSize)
        jumpButton.addTarget(self, action: #selector(jumpButtonTapped), for: .touchUpInside)
        jumpButton.setImage(#imageLiteral(resourceName: "JumpButton"), for: .normal)
        jumpButton.setImage(#imageLiteral(resourceName: "JumpButtonDown"), for: .highlighted)
        addSubview(jumpButton)
        self.jumpButton = jumpButton
        // Hook Button
        let hookButton = UIButton(type: .custom)
        let hookButtonX = bounds.width - (buttonSize + buttonMargin) * 2
        let hookButtonY = bounds.height - buttonSize - buttonMargin
        hookButton.frame = CGRect(x: hookButtonX, y: hookButtonY, width: buttonSize, height: buttonSize)
        hookButton.addTarget(self, action: #selector(hookButtonTapped), for: .touchUpInside)
        hookButton.setImage(#imageLiteral(resourceName: "GrapplingHookButton"), for: .normal)
        hookButton.setImage(#imageLiteral(resourceName: "GrapplingHookButtonDown"), for: .highlighted)
        addSubview(hookButton)
        self.hookButton = hookButton
    }

    private func setupGestureRecognizers() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        panGesture.cancelsTouchesInView = false
        panGesture.delegate = self
        addGestureRecognizer(panGesture)

        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        longPressGesture.minimumPressDuration = 0.2 // Adjust the duration as needed
        longPressGesture.allowableMovement = joystickBackgroundWidth * 2
        longPressGesture.delegate = self
        addGestureRecognizer(longPressGesture)
    }

    // MARK: Gesture handler methods

    @objc
    func hookButtonTapped() {
        controlViewDelegate?.hookButtonPressed(from: self)
    }

    @objc
    func jumpButtonTapped() {
        controlViewDelegate?.jumpButtonPressed(from: self)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)

        guard let joystickView = joystickView,
              let firstTouch = touches.first,
              firstTouch.location(in: self).x < self.frame.width / 2,
              touches.count == 1 else {
            return
        }

        if shouldSendMoveEvent(location: firstTouch.location(in: self)) {
            let isLeft = firstTouch.location(in: joystickView).x < joystickView.bounds.midX
            controlViewDelegate?.joystickMoved(toLeft: isLeft, from: self)
        }
        joystickView.moveJoystick(location: firstTouch.location(in: joystickView))
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)

        guard let firstTouch = touches.first?.location(in: self),
              firstTouch.x < self.frame.width / 2 else {
            return
        }

        controlViewDelegate?.joystickReleased(from: self)
        joystickView?.returnJoystick()
    }
    // To ensure gesture recognise only in a specific area
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let touchLocation = touch.location(in: self)
        let halfScreenWidth = self.frame.width / 2
        let ignoredAreaRect = CGRect(x: halfScreenWidth, y: 0, width: .infinity, height: self.frame.height)
        if ignoredAreaRect.contains(touchLocation) {
            return false
        }
        return true
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        true
     }

    @objc
    private func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
        switch gesture.state {
        case .began:
            startLongPressTimer(gesture)
        case .ended, .cancelled:
            stopLongPressTimer()
        default:
            break
        }
    }
    
    private func touchInActionButton(touchPoint: CGPoint) -> Bool {
        guard let jumpButton = jumpButton,
              let hookButton = hookButton else {
            return false
        }
        return jumpButton.frame.contains(touchPoint) || hookButton.frame.contains(touchPoint)
    }

    private func startLongPressTimer(_ gesture: UILongPressGestureRecognizer) {
            
            longPressTimer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { [weak self] _ in
            let touchPoint = gesture.location(in: self)
        
            guard let self = self,
                let joystickView = self.joystickView,
                  !touchInActionButton(touchPoint: touchPoint) else {
                return
            }
            
            if shouldSendMoveEvent(location: touchPoint) {
                let isLeft = gesture.location(in: joystickView).x < joystickView.bounds.midX
                controlViewDelegate?.joystickMoved(toLeft: isLeft, from: self)
            }
        }
    }

    private func stopLongPressTimer() {
        guard let joystickView = self.joystickView else {
            return
        }
        controlViewDelegate?.joystickReleased(from: self)
        joystickView.returnJoystick()
        longPressTimer?.invalidate()
        longPressTimer = nil
    }
    @objc
    func handlePan(_ gesture: UIPanGestureRecognizer) {
        let location = gesture.location(in: self)
        guard let joystickView = self.joystickView,
              location.x < self.frame.width / 2 else {
            return
        }

        if gesture.state == .ended {
            controlViewDelegate?.joystickReleased(from: self)
            joystickView.returnJoystick()
            return
        }

        joystickView.moveJoystick(location: gesture.location(in: joystickView))
        if shouldSendMoveEvent(location: location) {
            let isLeft = gesture.location(in: joystickView).x < joystickView.bounds.midX
            controlViewDelegate?.joystickMoved(toLeft: isLeft, from: self)
        }
    }

    private func shouldSendMoveEvent(location: CGPoint) -> Bool {
        true
    }
}
