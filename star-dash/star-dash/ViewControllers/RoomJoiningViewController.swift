//
//  RoomJoiningViewController.swift
//  star-dash
//
//  Created by Lau Rui han on 8/4/24.
//

import Foundation
import UIKit

struct NetworkData {
    let networkManager: NetworkManager
    let roomCode: String
    let playerIndex: Int
    let totalNumberOfPlayers: Int
}

class RoomJoiningViewController: UIViewController {
    let networkManager: NetworkManager = .init()
    var roomCode: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        networkManager.delegate = self
        if let roomCode = roomCode {
            networkManager.joinRoom(room: roomCode)
        }
    }
    func moveToLobby(playerIndex: Int, totalNumberOfPlayers: Int) {
        guard let roomCode = roomCode else {
            return
        }
        let networkData = NetworkData(networkManager: networkManager,
                                      roomCode: roomCode,
                                      playerIndex: playerIndex,
                                      totalNumberOfPlayers: totalNumberOfPlayers)
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "lobbySegue", sender: networkData)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "lobbySegue" {
            if let destinationVC = segue.destination as? LobbyViewController {
                if let data = sender as? NetworkData {
                    destinationVC.roomCode = data.roomCode
                    destinationVC.playerIndex = data.playerIndex
                    destinationVC.totalNumberOfPlayers = data.totalNumberOfPlayers
                    destinationVC.networkManager = data.networkManager
                }
            }
        }
    }
}

extension RoomJoiningViewController: NetworkManagerDelegate {
    func networkManager(_ networkManager: NetworkManager, didReceiveEvent response: Data) {
        guard let event = NetworkEventFactory.decodeNetworkEvent(from: response) as? NetworkPlayerJoinEvent else {
            return
        }
        print(event)
        moveToLobby(playerIndex: event.playerIndex, totalNumberOfPlayers: event.totalNumberOfPlayers)
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
