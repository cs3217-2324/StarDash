protocol ControlViewDelegate: AnyObject {

    func joystickMoved(toLeft: Bool, from view: ControlView)
    func joystickReleased(from view: ControlView)
    func jumpButtonPressed(from view: ControlView)
}
