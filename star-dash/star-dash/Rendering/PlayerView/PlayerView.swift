import UIKit
import MetalKit
import CoreGraphics

/**
 `PlayerView` is responsible for creating and coordinating the views
 for a specific player.

 It consists of 3 views:
 1. Scene View: The game from the player's perspective
 2. Control View: The controls the player interacts with
 3. Overlay View: The game overlay to show information such as points
 */
class PlayerView {
    let superview: UIView

    var sceneView: MTKView
    var controlView: ControlView
    var overlayView: OverlayView

    let rotation: CGFloat

    private init(superview: UIView, rotation: CGFloat, device: MTLDevice) {
        self.rotation = rotation
        self.superview = superview

        self.sceneView = MTKView(frame: superview.bounds, device: device)
        superview.addSubview(self.sceneView)

        self.overlayView = OverlayView(frame: superview.bounds, rotatedBy: rotation)
        superview.addSubview(self.overlayView)

        self.controlView = ControlView(frame: superview.bounds, rotatedBy: rotation)
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
        sceneView.delegate = delegate
    }

    func updateOverlay(score: Int) {
        overlayView.update(score: score)
    }

    static func createPlayerView(layout: PlayerViewLayout, device: MTLDevice) -> PlayerView {
        let playerView = PlayerView(superview: layout.superview, rotation: layout.rotation, device: device)
        playerView.setupSubviews()
        return playerView
    }
}
