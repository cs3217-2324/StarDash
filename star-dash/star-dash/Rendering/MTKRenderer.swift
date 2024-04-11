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
    //TODO: To be refined on how to follow the correct player index if on network
    var playerIndex: Int?
    
    init?(scene: GameScene) {
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

    private func playerIndex(from mtkView: MTKView) -> Int? {
        guard let playerIndex = playerIndex else {
            for i in 0..<playerViews.count where playerViews[i].sceneView == mtkView {
                return i
            }
            return nil
        }

        return playerIndex
    }

    private func playerIndex(from controlView: ControlView) -> Int? {
        guard let playerIndex = playerIndex else {
            for i in 0..<playerViews.count where playerViews[i].controlView == controlView {
                return i
            }
            return nil
        }

        return playerIndex
    }
}

extension MTKRenderer: MTKViewDelegate {
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {

    }

    func draw(in view: MTKView) {
        guard let renderPassDescriptor = view.currentRenderPassDescriptor,
              let commandBuffer = commandQueue.makeCommandBuffer(),
              let drawable = view.currentDrawable,
              let playerIndex = playerIndex(from: view) else {
            return
        }
        let viewport = CGRect(x: 0, y: 0, width: view.drawableSize.width, height: view.drawableSize.height)

        updateScene(forPlayer: playerIndex)
        renderer.render(
            withViewport: viewport,
            commandBuffer: commandBuffer,
            renderPassDescriptor: renderPassDescriptor
        )

        commandBuffer.commit()
        commandBuffer.waitUntilCompleted()
        drawable.present()
    }

    func updateScene(forPlayer playerIndex: Int) {
        guard let overlayInfo = viewDelegate?.overlayInfo(forPlayer: playerIndex) else {
                return
        }
        var index = playerIndex
        //TODO: Refine how playerindex is passed
        if let playerIndex = self.playerIndex {
            index = 0
        } else {
            index = playerIndex
        }

        if index == 0 {
            // Ensures all views displays the game scene of the same state
            // Assumption: The first view is always the start of the every cycle of updates
            renderer.update(atTime: CACurrentMediaTime())
        }
        playerViews[index].update(overlayInfo)
        scene.useCamera(of: playerIndex, rotatedBy: playerViews[index].rotation)
        }
}

extension MTKRenderer: ControlViewDelegate {
    func joystickMoved(toLeft: Bool, from view: ControlView) {
        guard let playerIndex = playerIndex(from: view) else {
            return
        }

        viewDelegate?.joystickMoved(toLeft: toLeft, playerIndex: playerIndex)
    }

    func joystickReleased(from view: ControlView) {
        guard let playerIndex = playerIndex(from: view) else {
            return
        }

        viewDelegate?.joystickReleased(playerIndex: playerIndex)
    }

    func jumpButtonPressed(from view: ControlView) {
        guard let playerIndex = playerIndex(from: view) else {
            return
        }

        viewDelegate?.jumpButtonPressed(playerIndex: playerIndex)
    }

    func hookButtonPressed(from view: ControlView) {
        guard let playerIndex = playerIndex(from: view) else {
            return
        }

        viewDelegate?.hookButtonPressed(playerIndex: playerIndex)
    }
}
