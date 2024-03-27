protocol ViewDelegate: AnyObject {

    func joystickMoved(toLeft: Bool, playerIndex: Int)
    func joystickReleased(playerIndex: Int)
    func jumpButtonPressed(playerIndex: Int)
    func overlayInfo(forPlayer playerIndex: Int) -> OverlayInfo?
}
