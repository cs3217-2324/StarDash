import UIKit

/**
 The `Renderer` protocol defines the requirements for an object responsible for rendering game objects onto a view.
 */
protocol Renderer {
    func createSinglePlayerView(at rootView: UIView)
}
