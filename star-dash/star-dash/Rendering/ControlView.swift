import UIKit

class ControlView: UIView {
    
    var joystickControl: UIView?
    var joystickBackground: UIView?
    
    let joystickRadius: CGFloat = 50
    let joystickBackgroundWidth: CGFloat = 256
    let panThreshold: CGFloat = 15

    func setupSubviews() {
        setupMovementControls()
        setupActionControls()
        setupGestureRecognizers()
    }

    private func setupMovementControls() {
        let joystickView = UIView()
        
        let buttonMargin: CGFloat = 50
        let buttonY = frame.height - joystickRadius * 2 - buttonMargin
        joystickView.frame = CGRect(x: buttonMargin, y: buttonY, width: joystickBackgroundWidth, height: joystickRadius * 2)
        
        let joystickBackground = UIImageView(image: #imageLiteral(resourceName: "JoystickBackground"))
        joystickBackground.frame = joystickView.bounds
        joystickBackground.alpha = 0.5
        joystickView.addSubview(joystickBackground)
        self.joystickBackground = joystickBackground
        
        let joystickControl = UIImageView(image: #imageLiteral(resourceName: "JoystickControl"))
        joystickControl.frame = CGRect(
            x: joystickView.frame.width / 2 - joystickRadius,
            y: joystickView.frame.height / 2 - joystickRadius,
            width: joystickRadius * 2,
            height: joystickRadius * 2
        )
        joystickView.addSubview(joystickControl)
        self.joystickControl = joystickControl
        
        addSubview(joystickView)
    }

    private func setupActionControls() {
        let jumpButton = UIButton(type: .custom)
        
        let buttonSize: CGFloat = 100
        let buttonMargin: CGFloat = 50
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

    @objc func jumpButtonTapped() {
        print("Tapped")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        guard let location = touches.first?.location(in: joystickBackground),
              touches.count == 1,
              touches.first?.location(in: self).x < self.frame.width / 2 else {
            return
        }

        moveJoystick(location: location)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        guard let location = touches.first?.location(in: self) else {
            return
        }
        
        returnJoystick()
    }
    
    @objc func handlePan(_ gesture: UIPanGestureRecognizer) {
        if (gesture.state == .ended) {
            returnJoystick()
        } else if gesture.location(in: self).x < self.frame.width / 2 {
            moveJoystick(location: gesture.location(in: joystickBackground))
        }
    }
    
    private func moveJoystick(location: CGPoint) {
        guard let joystickControl = self.joystickControl,
              let joystickBackground = self.joystickBackground else {
            return
        }
        
        UIView.cancelPreviousPerformRequests(withTarget: joystickControl)
        
        let midPoint = joystickBackground.center
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
    
    private func returnJoystick() {
        guard let joystickControl = joystickControl,
              let joystickBackground = joystickBackground else {
            return
        }

        UIView.animate(withDuration: 0.8, delay: 0, options: .curveEaseOut, animations: {
            joystickControl.center = joystickBackground.center
        })
    }
    
    private func shouldSendMoveEvent(location: CGPoint) -> Bool {
        false
    }
}
