import UIKit
import MetalKit

/**
 `PlayerView` is responsible for creating and coordinating the views
 for a specific player.

 It consists of 3 views:
 1. Scene View: The game from the player's perspective
 2. Control View: The controls the player interacts with
 3. Overlay View: The game overlay to show information such as points
 */
class PlayerView {
    var sceneView: MTKView
    var controlView: ControlView
    var overlayView: OverlayView

    private init(superview: UIView, device: MTLDevice) {
        self.sceneView = MTKView(frame: superview.frame, device: device)
        superview.addSubview(self.sceneView)

        self.overlayView = OverlayView(frame: superview.frame)
        superview.addSubview(self.overlayView)

        self.controlView = ControlView(frame: superview.frame)
        superview.addSubview(self.controlView)
    }

    func setupSubviews() {
        self.controlView.setupSubviews()
        self.overlayView.setupSubviews()
    }

    func setControlViewDelegate(_ delegate: ControlViewDelegate) {
        controlView.controlViewDelegate = delegate
    }

    func setDrawDelegate(_ delegate: MTKViewDelegate) {
        sceneView.delegate = drawDelegate
    }

    func updateOverlay(score: Int) {
        overlayView.update(score: score)
    }

    static func createPlayerView(layout: PlayerViewLayout, device: MTLDevice) -> PlayerView {
        let playerView = PlayerView(superview: layout.superview, device: device)
        playerView.setupSubviews()
        return playerView
    }
}
