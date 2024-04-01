//
//  MenuViewController.swift
//  star-dash
//
//  Created by Lau Rui han on 1/4/24.
//

import Foundation
import UIKit

class MenuViewController: UIViewController {
    
    @IBAction private func singlePlayer(_ sender: Any) {
        print("Single button tapped")
        ViewController.gameMode = 1
        performSegue(withIdentifier: "PlaySegue", sender: self)
    }
    @IBAction func localMultiplayer(_ sender: Any) {
        print("Local multiplayer")
        ViewController.gameMode = 2
        performSegue(withIdentifier: "PlaySegue", sender: self)
    }
}
