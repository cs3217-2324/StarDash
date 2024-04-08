//
//  NetworkManager.swift
//  star-dash
//
//  Created by Lau Rui han on 8/4/24.
//

import Foundation

protocol NetworkManagerDelegate: AnyObject {
    func networkManager(_ networkManager: NetworkManager, didReceiveMessage message: String)
    func networkManager(_ networkManager: NetworkManager, didEncounterError error: Error)
    func networkManager(_ networkManager: NetworkManager, didReceiveAPIResponse response: Any)
    func networkManager(_ networkManager: NetworkManager, didReceiveEvent response: Data)

}

class NetworkManager {
    let serverAddress: String
    let serverPort: Int
    var socketManager: SocketManager?
    weak var delegate: NetworkManagerDelegate?

    init(serverAddress: String, serverPort: Int) {
        self.serverAddress = serverAddress
        self.serverPort = serverPort
    }
    convenience init() {
        self.init(serverAddress: NetworkConstants.serverUrl, serverPort: NetworkConstants.serverPort)
    }
    func createRoom() {
        self.performGETRequest(prefix: "/create_room")
    }
    func joinRoom(room: String) {
        self.socketManager = SocketManager(address: NetworkConstants.serverUrl + "/join_room/" + room)
        self.socketManager?.delegate = self
    }

    func performGETRequest(prefix: String) {
        guard let url = URL(string: self.serverAddress + prefix) else {
            delegate?.networkManager(self, didEncounterError: NetworkManagerError.invalidURL)
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                self.delegate?.networkManager(self, didEncounterError: error)
                return
            }

            guard let data = data else {
                self.delegate?.networkManager(self, didEncounterError: NetworkManagerError.noDataReceived)
                return
            }
            self.delegate?.networkManager(self, didReceiveEvent: data)

        }
    }
}

// extension NetworkManager: SocketManagerDelegate {
//    func socketManager(_ socketManager: SocketManager, didReceiveMessage message: String) {
//        print(message)
//        delegate?.networkManager(self, didReceiveMessage: message)
//    }
//    
//    func socketManager(_ socketManager: SocketManager, didEncounterError error: Error) {
//        delegate?.networkManager(self, didEncounterError: error)
//    }
//    
// }

enum NetworkManagerError: Error {
    case invalidURL
    case noDataReceived
    // Add more errors as needed
}

extension NetworkManager: SocketManagerDelegate {
    func socketManager(_ socketManager: SocketManager, didReceiveMessage message: Data) {
        self.delegate?.networkManager(self, didReceiveEvent: message)
    }

    func socketManager(_ socketManager: SocketManager, didEncounterError error: Error) {

    }

}
