//
//  LobbyViewController.swift
//  star-dash
//
//  Created by Lau Rui han on 8/4/24.
//

import Foundation
import UIKit

class LobbyViewController: UIViewController {
    var networkManager: NetworkManager?
    var roomCode: String?
    var playerIndex: Int?
    var totalNumberOfPlayers: Int?
    @IBOutlet private var RoomCodeContainer: UIStackView!

    @IBOutlet weak var label: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let networkManager = networkManager else {
            return
        }
        networkManager.delegate = self

        setUpCodeContainer()
        updateLabel()
    }
    func setUpCodeContainer() {
        guard let roomCode = roomCode else {
            return
        }
        // Clear any existing labels in the RoomCodeContainer
        RoomCodeContainer.arrangedSubviews.forEach { $0.removeFromSuperview() }

        // Loop through each character in the roomCode
        for character in roomCode {
            // Create a label
            let containerView = UIView()
            containerView.backgroundColor = .clear
            containerView.layer.borderWidth = 2
            containerView.layer.borderColor = UIColor.black.cgColor
            containerView.layer.cornerRadius = 6
            containerView.widthAnchor.constraint(equalToConstant: 100).isActive = true
            containerView.heightAnchor.constraint(equalToConstant: 100).isActive = true
            // Create an image view
            let character = String(character)
            let imageView = UIImageView(image: UIImage(named: RoomCodeConstants.numberToFruit[character] ?? ""))
            imageView.contentMode = .scaleAspectFit
            imageView.translatesAutoresizingMaskIntoConstraints = false
            // Create a stack view to hold the label and image view horizontally
            containerView.addSubview(imageView)
            // Add the stack view to the RoomCodeContainer
            NSLayoutConstraint.activate([
                imageView.leadingAnchor.constraint(
                    equalTo: containerView.leadingAnchor,
                    constant: 10), // Adjust padding as needed
                imageView.trailingAnchor.constraint(
                    equalTo: containerView.trailingAnchor,
                    constant: -10), // Adjust padding as needed
                imageView.topAnchor.constraint(
                    equalTo: containerView.topAnchor,
                    constant: 10), // Adjust padding as needed
                imageView.bottomAnchor.constraint(
                    equalTo: containerView.bottomAnchor,
                    constant: -10) // Adjust padding as needed
            ])
            RoomCodeContainer.addArrangedSubview(containerView)
        }
    }
    
    func updateLabel() {
        guard let totalNumberOfPlayers = totalNumberOfPlayers else {
            return
        }
        self.label.text = "Waiting for players (\(totalNumberOfPlayers) / 4)"
    }

}

extension LobbyViewController: NetworkManagerDelegate {
    func networkManager(_ networkManager: NetworkManager, didReceiveEvent response: Data) {
        guard let event = decodeNetworkEvent(from: response) as? NetworkPlayerJoinEvent else {
            return
        }
        totalNumberOfPlayers = event.totalNumberOfPlayers
        updateLabel()
        
    }

    func networkManager(_ networkManager: NetworkManager, didReceiveMessage message: String) {
        print(message)
    }

    func networkManager(_ networkManager: NetworkManager, didEncounterError error: Error) {
        print(error)
    }

    func networkManager(_ networkManager: NetworkManager, didReceiveAPIResponse response: Any) {

    }

}
