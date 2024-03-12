import UIKit
import SpriteKit
import MetalKit

class MTKRenderer: NSObject {
    var scene: GameScene
    var device: MTLDevice
    var commandQueue: MTLCommandQueue

    var renderer: SKRenderer

    var sceneView: MTKView?
    var controlView: UIView?

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

    func createSinglePlayerView(rootView: UIView) {
        let sceneView = MTKView()
        sceneView.frame = rootView.frame
        sceneView.device = self.device
        sceneView.delegate = self
        self.sceneView = sceneView
        rootView.addSubview(sceneView)

        let controlView = UIView(frame: rootView.frame)
        controlView.setupActionControls()
        rootView.addSubview(controlView)
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
