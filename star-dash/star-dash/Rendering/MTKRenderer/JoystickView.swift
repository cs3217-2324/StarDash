import UIKit

class JoystickView: UIView {

    let joystickBackground: UIView
    let joystickControl: UIView

    init(frame: CGRect, buttonSize: CGFloat) {
        self.joystickBackground = UIImageView(image: #imageLiteral(resourceName: "JoystickBackground"))
        joystickBackground.frame = CGRect(
            x: 0, y: 0, width: frame.width, height: frame.height
        )
        joystickBackground.alpha = 0.5
        
        self.joystickControl = UIImageView(image: #imageLiteral(resourceName: "JoystickControl"))
        joystickControl.frame = CGRect(
            x: frame.width / 2 - buttonSize / 2,
            y: frame.height / 2 - buttonSize / 2,
            width: buttonSize,
            height: buttonSize
        )
        
        super.init(frame: frame)
        
        addSubview(joystickBackground)
        addSubview(joystickControl)
    }
    
    required init?(coder: NSCoder) {
        self.joystickBackground = UIImageView(image: #imageLiteral(resourceName: "JoystickBackground"))
        self.joystickControl = UIImageView(image: #imageLiteral(resourceName: "JoystickControl"))
        super.init(coder: coder)
    }

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
    
    func returnJoystick() {
        UIView.animate(withDuration: 0.8, delay: 0, options: .curveEaseOut, animations: {
            self.joystickControl.center = self.joystickBackground.center
        })
    }
    
    private func shouldSendMoveEvent(location: CGPoint) -> Bool {
        false
    }
}
