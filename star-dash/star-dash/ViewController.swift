//
//  ViewController.swift
//  star-dash
//
//  Created by Lau Rui han on 12/3/24.
//

import UIKit

class ViewController: UIViewController {

    var scene: GameScene?
    var renderer: Renderer?

    override func viewDidLoad() {
        super.viewDidLoad()

        let scene = GameScene(size: self.view.bounds.size)
        scene.setupGame()
        self.scene = scene
        
        guard let renderer = MTKRenderer(scene: scene) else {
            return
        }

        renderer.createSinglePlayerView(at: self.view)
        self.renderer = renderer
    }

}

