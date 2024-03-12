import UIKit
import SpriteKit
import MetalKit

class MTKRenderer: NSObject, Renderer {
    var scene: GameScene
    var device: MTLDevice
    var commandQueue: MTLCommandQueue

    var renderer: SKRenderer

    var playerView: PlayerView?

    init?(scene: GameScene) {
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

    func createSinglePlayerView(at rootView: UIView) {
        let playerView = PlayerView(rootView: rootView, drawDelegate: self)
        playerView.setupSubviews()
        self.playerView = playerView
    }
}

extension MTKRenderer: MTKViewDelegate {
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        return
    }
    
    func draw(in view: MTKView) {
        guard let renderPassDescriptor = view.currentRenderPassDescriptor,
            let commandBuffer = commandQueue.makeCommandBuffer(),
            let drawable = view.currentDrawable else {
            return
        }
        renderer.update(atTime: CACurrentMediaTime())
        
        let viewport = CGRect(x: 0, y: 0, width: view.drawableSize.width, height: view.drawableSize.height)
        renderer.render(withViewport: viewport, commandBuffer: commandBuffer, renderPassDescriptor: renderPassDescriptor)
        
        commandBuffer.present(drawable)
        commandBuffer.commit()
    }
}
