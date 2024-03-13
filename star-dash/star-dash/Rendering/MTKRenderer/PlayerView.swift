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

    init(superview: UIView, device: MTLDevice, drawDelegate: MTKViewDelegate) {
        self.sceneView = MTKView(frame: superview.frame, device: device)
        self.sceneView.delegate = drawDelegate
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
}
