class JoystickView: UIView {

    let joystickBackground: UIView
    let joystickControl: UIView

    init(frame: CGRect) {
        self.joystickBackground = UIImageView(image: #imageLiteral(resourceName: "JoystickBackground"))
        joystickBackground.frame = frame
        joystickBackground.alpha = 0.5
        addSubview(joystickBackground)
        
        self.joystickControl = UIImageView(image: #imageLiteral(resourceName: "JoystickControl"))
        joystickControl.frame = CGRect(
            x: joystickView.frame.width / 2 - buttonSize / 2,
            y: joystickView.frame.height / 2 - buttonSize / 2,
            width: buttonSize,
            height: buttonSize
        )
        addSubview(joystickControl)
    }

    func moveJoystick(location: CGPoint) {
        guard let joystickControl = self.joystickControl,
              let joystickBackground = self.joystickBackground else {
            return
        }
        
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
    
    func returnJoystick() {
        guard let joystickControl = joystickControl,
              let joystickBackground = joystickBackground else {
            return
        }

        UIView.animate(withDuration: 0.8, delay: 0, options: .curveEaseOut, animations: {
            joystickControl.center = joystickBackground.center
        })
    }
}