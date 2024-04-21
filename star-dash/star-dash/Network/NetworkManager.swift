//
//  NetworkManager.swift
//  star-dash
//
//  Created by Lau Rui han on 8/4/24.
//

import Foundation

protocol NetworkManagerDelegate: AnyObject {
    func networkManager(_ networkManager: NetworkManager, didReceiveEvent event: Data)
    func networkManager(_ networkManager: NetworkManager, didEncounterError error: Error)
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
    private func encodeNetworkEvent<T: Encodable>(_ event: T) throws -> Data {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601

        return try encoder.encode(event)
    }

    func sendEvent(event: NetworkEvent) {
        do {
             let data = try encodeNetworkEvent(event)
            socketManager?.emit(data: data)
        } catch {
            print("error sending event \(error)")
        }
    }
    private func performGETRequest(prefix: String) {
        guard let url = URL(string: self.serverAddress + prefix) else {
            delegate?.networkManager(self, didEncounterError: NetworkError.invalidURL)
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                self.delegate?.networkManager(self, didEncounterError: error)
                print(error)
                return
            }
            guard let data = data else {
                self.delegate?.networkManager(self, didEncounterError: NetworkError.noDataReceived)
                return
            }
                self.delegate?.networkManager(self, didReceiveEvent: data)

        }
        task.resume()
    }

    func disconnect() {
        socketManager?.closeConnection()
    }
}

extension NetworkManager: SocketManagerDelegate {
    func socketManager(_ socketManager: SocketManager, didReceiveMessage message: Data) {
        self.delegate?.networkManager(self, didReceiveEvent: message)
    }

    func socketManager(_ socketManager: SocketManager, didEncounterError error: Error) {
        self.delegate?.networkManager(self, didEncounterError: error)
    }

}
