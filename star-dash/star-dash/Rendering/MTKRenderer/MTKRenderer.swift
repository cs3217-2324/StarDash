import UIKit
import SpriteKit
import MetalKit

/**
 `MTKRenderer` is a `Renderer` that uses MetalKit and SpriteKit to render
 the game on to the iOS device.

 The `SKScene` is rendered through a MetalKit while the controls
 and game information overlay is rendered through UIKit.
 */
class MTKRenderer: NSObject, Renderer {
    var scene: SKScene
    var device: MTLDevice
    var commandQueue: MTLCommandQueue

    var renderer: SKRenderer

    var playerView: PlayerView?

    var viewDelegate: ViewDelegate?

    init?(scene: SKScene) {
        self.scene = scene

        guard let device = MTLCreateSystemDefaultDevice(),
              let commandQueue = device.makeCommandQueue() else {
            return nil
        }
        self.device = device
        self.commandQueue = commandQueue
        self.renderer = SKRenderer(device: device)
        renderer.scene = scene

        super.init()
    }

    func updateOverlay(overlayInfo: OverlayInfo) {
        playerView?.updateOverlay(score: overlayInfo.score)
    }

    /// Set ups the views for a single player game.
    func createSinglePlayerView(at superview: UIView) {
        let playerView = PlayerView(superview: superview, device: self.device, drawDelegate: self)
        playerView.setupSubviews()
        playerView.setControlViewDelegate(self)
        self.playerView = playerView
    }
}

extension MTKRenderer: MTKViewDelegate {
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {

    }

    func draw(in view: MTKView) {
        guard let renderPassDescriptor = view.currentRenderPassDescriptor,
              let commandBuffer = commandQueue.makeCommandBuffer(),
              let drawable = view.currentDrawable else {
            return
        }
        renderer.update(atTime: CACurrentMediaTime())

        let viewport = CGRect(x: 0, y: 0, width: view.drawableSize.width, height: view.drawableSize.height)
        renderer.render(
            withViewport: viewport,
            commandBuffer: commandBuffer,
            renderPassDescriptor: renderPassDescriptor
        )

        commandBuffer.present(drawable)
        commandBuffer.commit()
    }
}

extension MTKRenderer: ControlViewDelegate {
    func joystickMoved(toLeft: Bool) {
        viewDelegate?.joystickMoved(toLeft: toLeft)
    }

    func joystickReleased() {
        viewDelegate?.joystickReleased()
    }

    func jumpButtonPressed() {
        viewDelegate?.jumpButtonPressed()
    }
}
