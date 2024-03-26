import UIKit
import SpriteKit
import MetalKit
import SDPhysicsEngine

/**
 `MTKRenderer` is a `Renderer` that uses MetalKit and SpriteKit to render
 the game on to the iOS device.

 The `SKScene` is rendered through a MetalKit while the controls
 and game information overlay is rendered through UIKit.
 */
class MTKRenderer: NSObject, Renderer {
    var scene: GameScene
    var device: MTLDevice
    var commandQueue: MTLCommandQueue

    var renderer: SKRenderer

    var playerViews: [PlayerView]

    var viewDelegate: ViewDelegate?

    init?(scene: GameScene, numberOfPlayers) {
        self.scene = scene

        guard let device = MTLCreateSystemDefaultDevice(),
              let commandQueue = device.makeCommandQueue() else {
            return nil
        }
        self.playerViews = []
        self.device = device
        self.commandQueue = commandQueue
        self.renderer = SKRenderer(device: device)
        renderer.scene = scene

        super.init()
    }

    func setupViews(at superview: UIView, for numberOfPlayers: Int) {
        guard let layouts = LayoutUtils.layoutViews(superview: superview, for: numberOfPlayers) else {
            return
        }

        for layout in layouts {
            let playerView = PlayerView.createPlayerView(layout: layout, device: self.device)
            playerView.setControlViewDelegate(self)
            playerView.setDrawDelegate(self)
            self.playerViews.append(playerView)
        }
    }

    func camera(of view: MTKView) -> SKCameraNode? {
        guard let playerIndex = playerIndex(from: view) {
            return nil
        }

        return self.scene.camera(of: playerIndex)
    }

    func updateOverlay(overlayInfo: OverlayInfo) {
        playerViews[0]?.updateOverlay(score: overlayInfo.score)
    }

    private func playerIndex(from mtkView: MTKView) -> Int? {
        for i in 0..<playerViews.length where playerViews[i]?.sceneView == mtkView {
            return i
        }

        return nil
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
        let viewport = CGRect(x: 0, y: 0, width: view.drawableSize.width, height: view.drawableSize.height)

        renderer.update(atTime: CACurrentMediaTime())
        renderer.camera = camera(of: view)        
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
