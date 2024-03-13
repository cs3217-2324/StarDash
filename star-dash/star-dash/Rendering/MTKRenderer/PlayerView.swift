import UIKit
import MetalKit

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
