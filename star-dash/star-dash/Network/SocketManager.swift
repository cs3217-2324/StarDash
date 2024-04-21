//
//  SocketManager.swift
//  star-dash
//
//  Created by Lau Rui han on 8/4/24.
//

import Foundation
import Starscream
 protocol SocketManagerDelegate: AnyObject {
    func socketManager(_ socketManager: SocketManager, didReceiveMessage message: Data)
    func socketManager(_ socketManager: SocketManager, didEncounterError error: Error)
 }

class SocketManager: NSObject, WebSocketDelegate {

    let address: String
    var isConnected: Bool?

    private var socket: WebSocket?
    weak var delegate: SocketManagerDelegate?
    init(address: String) {
        self.address = address
        super.init()
        configureSocketClient()
    }

    private func configureSocketClient() {

        guard let url = URL(string: address) else {
            return
        }
        var request = URLRequest(url: url)
        request.timeoutInterval = 5
        socket = WebSocket(request: request)
        socket?.delegate = self
        socket?.connect()

    }

    func emit(data: Data) {
        guard let socket = socket else {
            return
        }
        socket.write(data: data)
    }

    func closeConnection() {
        socket?.disconnect()
    }

    func didReceive(event: Starscream.WebSocketEvent, client: Starscream.WebSocketClient) {

        switch event {
        case .connected(let headers):
            isConnected = true
            print("websocket is connected: \(headers)")
        case .disconnected(let reason, _):
            isConnected = false
            handleDisconnect(reason: reason)
        case .text(let string):
            handleEvent(string: string)
        case .binary(let data):
            print("Received data: \(data.count)")
        case .ping, .pong:
            break
        case .viabilityChanged, .reconnectSuggested:
            break
        case .cancelled:
            isConnected = false
        case .error:
            isConnected = false
        case .peerClosed:
            break
        }
    }

    private func handleEvent(string: String) {
        if let data = string.data(using: .utf8) {
            self.delegate?.socketManager(self, didReceiveMessage: data)
        }

    }

    private func handleDisconnect(reason: String) {
        guard let networkError = NetworkError(rawValue: reason) else {
            self.delegate?.socketManager(self, didEncounterError: NetworkError.UnknownError)
            return
        }
        self.delegate?.socketManager(self, didEncounterError: networkError)
    }
}
