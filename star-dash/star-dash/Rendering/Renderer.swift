import UIKit

/**
 The `Renderer` protocol defines the requirements for an object responsible for rendering game objects onto a view.
 */
protocol Renderer {
    func setupViews(at rootView: UIView, for numberOfPlayers: Int)
    func setupCameras(for numberOfPlayers: Int)
}
