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

    @IBOutlet private var startButton: UIButton!
    @IBOutlet private var label: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let networkManager = networkManager else {
            return
        }
        networkManager.delegate = self
        if playerIndex != 0 {
            disableStartButton()
        }
        setUpCodeContainer()
        updateLabel()
    }

    func disableStartButton() {
        startButton.setTitle("Waiting for host to start", for: .disabled)
        startButton.setTitleColor(UIColor.darkGray, for: .disabled)
        startButton.isEnabled = false
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
    func moveToLevelSelection() {
        guard let totalNumberOfPlayers = totalNumberOfPlayers,
        let playerIndex = playerIndex else {
            return
        }
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "MoveLevelSelection",
                              sender: GameData(level: nil,
                                               numberOfPlayers: totalNumberOfPlayers,
                                               viewLayout: 1,
                                               gameMode: nil,
                                               storageManager: StorageManager(),
                                               networkManager: self.networkManager,
                                               playerIndex: playerIndex))
        }

    }

    func moveToMenu() {
        networkManager?.disconnect()

        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "BackMenuSegue",
                              sender: self)
        }
    }

    @IBAction private func start(_ sender: Any) {
        guard let playerIndex = playerIndex else {
            return
        }
        networkManager?.sendEvent(event: NetworkMoveToLevelSelectionEvent(playerIndex: playerIndex))
    }

    @IBAction private func backButton(_ sender: Any) {
        let alert = UIAlertController(title: "Was that an accident?",
                                      message: "Do you want to go back to main menu?",
                                      preferredStyle: .alert)

                // You can add actions using the following code
        alert.addAction(UIAlertAction(title: "Yes",
                                      style: .default,
                                      handler: { _ in
                self.moveToMenu()
            }))
        alert.addAction(UIAlertAction(title: "No",
                                      style: .default,
                                      handler: nil))

                // This part of code inits alert view
        self.present(alert, animated: true, completion: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MoveLevelSelection" {
            if let destinationVC = segue.destination as? LevelSelectorViewController {
                if let data = sender as? GameData {
                    destinationVC.viewLayout = data.viewLayout
                    destinationVC.numberOfPlayers = data.numberOfPlayers
                    destinationVC.storageManager = data.storageManager
                    destinationVC.networkManager = data.networkManager
                    destinationVC.playerIndex = data.playerIndex
                }
            }
        }
    }
}

extension LobbyViewController: NetworkManagerDelegate {
    func networkManager(_ networkManager: NetworkManager, didReceiveEvent response: Data) {
        if let event = NetworkEventFactory.decodeNetworkEvent(from: response) as? NetworkPlayerJoinEvent {
            totalNumberOfPlayers = event.totalNumberOfPlayers
            updateLabel()
        }
        if let event = NetworkEventFactory.decodeNetworkEvent(from: response) as? NetworkPlayerLeaveRoomEvent {
            totalNumberOfPlayers = event.totalNumberOfPlayers
            playerIndex = event.newPlayerIndex
            updateLabel()
        }

        if NetworkEventFactory.decodeNetworkEvent(from: response) as? NetworkMoveToLevelSelectionEvent != nil {
            moveToLevelSelection()
        }

    }

    func networkManager(_ networkManager: NetworkManager, didEncounterError error: Error) {
        print(error)
    }

}
