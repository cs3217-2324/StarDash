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
        let sceneView = createSceneView(frame: rootView.frame)
        self.sceneView = sceneView
        rootView.addSubview(sceneView)

        let controlView = createControlView(frame: rootView.frame)
        self.controlView = controlView
        rootView.addSubview(controlView)
    }

    private func createSceneView(frame: CGRect) -> MTKView {
        let sceneView = MTKView(frame: frame, device: self.device)
        sceneView.delegate = self

        return sceneView
    }

    private func createControlView(frame: CGRect) -> UIView {
        let controlView = UIView(frame: frame)
        controlView.setupActionControls()
        return controlView
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
