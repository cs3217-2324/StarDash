//
//  RoomCreationViewController.swift
//  star-dash
//
//  Created by Lau Rui han on 8/4/24.
//

import Foundation
import UIKit
class RoomCreationViewController: UIViewController {
    let networkManager: NetworkManager = .init()
    override func viewDidLoad() {
        super.viewDidLoad()
        networkManager.delegate = self
        networkManager.createRoom()
    }
    func moveToLobby(roomCode: String) {
        DispatchQueue.main.async {
                self.performSegue(withIdentifier: "joinRoomSegue", sender: roomCode)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "joinRoomSegue" {
            if let destinationVC = segue.destination as? RoomJoiningViewController {
                if let data = sender as? String {
                    destinationVC.roomCode = data
                }
            }
        }
    }

}

extension RoomCreationViewController: NetworkManagerDelegate {

    func networkManager(_ networkManager: NetworkManager, didReceiveEvent response: Data) {
        if let event = NetworkEventFactory.decodeNetworkEvent(from: response) as? NetworkCreateRoomEvent {
            moveToLobby(roomCode: event.roomCode)
        }
    }

    func networkManager(_ networkManager: NetworkManager, didEncounterError error: Error) {
        print(error)
    }

}
