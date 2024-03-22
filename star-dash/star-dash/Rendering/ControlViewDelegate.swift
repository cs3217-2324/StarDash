protocol ControlViewDelegate: AnyObject {

    func joystickMoved(toLeft: Bool)
    func joystickReleased()
    func jumpButtonPressed()
}
