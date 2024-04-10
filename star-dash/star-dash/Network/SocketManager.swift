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
//    private var manager: SocketManager?
//
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
        print("Conecting to : \(address)")
        var request = URLRequest(url: url)
        request.timeoutInterval = 5
        socket = WebSocket(request: request)
        socket?.delegate = self
        socket?.connect()

    }

    func closeConnection() {

//            guard let socket = manager?.defaultSocket else {
//                return
//            }
//
//            socket.disconnect()
        }
    
    func emit(data: Data) {
        guard let socket = socket else {
            return
        }
        socket.write(data: data)
    }
    func didReceive(event: Starscream.WebSocketEvent, client: Starscream.WebSocketClient) {
        print(event)
        switch event {
        case .connected(let headers):
            isConnected = true
            print("websocket is connected: \(headers)")
        case .disconnected(let reason, let code):
            isConnected = false
            print("websocket is disconnected: \(reason) with code: \(code)")
        case .text(let string):
            if let jsonData = string.data(using: .utf8) {
                // Decode JSON into a generic Decodable type
                print(jsonData)
                self.delegate?.socketManager(self, didReceiveMessage: jsonData)
                break
            }
        case .binary(let data):
            print("Received data: \(data.count)")
        case .ping:
            break
        case .pong:
            break
        case .viabilityChanged:
            break
        case .reconnectSuggested:
            break
        case .cancelled:
            isConnected = false
        case .error(let error):
            isConnected = false
            case .peerClosed:
                   break
        }
    }
}

enum SocketHelperError: Error {
    case socketConnectionNotEstablished
    // Add more errors as needed
}
