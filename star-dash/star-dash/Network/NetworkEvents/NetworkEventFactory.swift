//
//  NetworkEventFactory.swift
//  star-dash
//
//  Created by Lau Rui han on 8/4/24.
//

import Foundation
typealias DecoderClosure = (Decoder) throws -> NetworkEvent?

class NetworkEventFactory {

    static func decodeNetworkEvent(from jsonData: Data) -> NetworkEvent? {
        let decoder = JSONDecoder()
        let decodingMap: [String: (Data) throws -> NetworkEvent] = [
            "player-join-room": { jsonData in try decoder.decode(NetworkPlayerJoinEvent.self, from: jsonData) },
            "player-leave-room": { jsonData in try decoder.decode(NetworkPlayerLeaveRoomEvent.self, from: jsonData) },
            "select-level": { jsonData in try decoder.decode(NetworkSelectLevelEvent.self, from: jsonData) },
            "player-move": { jsonData in try decoder.decode(NetworkPlayerMoveEvent.self, from: jsonData) },
            "move-to-level-selection": { jsonData in
                try decoder.decode(NetworkMoveToLevelSelectionEvent.self, from: jsonData) },
            "player-jump": { jsonData in try decoder.decode(NetworkPlayerJumpEvent.self, from: jsonData) },
            "player-hook": { jsonData in try decoder.decode(NetworkPlayerHookEvent.self, from: jsonData) },
            "player-stop": { jsonData in try decoder.decode(NetworkPlayerStopEvent.self, from: jsonData) },
            "sync": { jsonData in try decoder.decode(NetworkSyncEvent.self, from: jsonData) }
        ]

        do {
            let networkEvent = try decoder.decode(NetworkEvent.self, from: jsonData)

            // Use the decodingMap to decode the event based on the eventType

            if let decodingClosure = decodingMap[networkEvent.event.rawValue] {
                let networkEvent = try decodingClosure(jsonData)
                return networkEvent
            } else {
                // Handle unknown event type
                print("Unknown event type")
                // You can either return a default event or throw an error
                // For now, let's return nil
                return nil
            }
        } catch {
            // Print and handle any decoding errors
            print(error)
        }

        // Return nil if decoding fails
        return nil
    }
}
