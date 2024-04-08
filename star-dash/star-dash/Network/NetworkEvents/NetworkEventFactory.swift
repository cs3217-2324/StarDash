//
//  NetworkEventFactory.swift
//  star-dash
//
//  Created by Lau Rui han on 8/4/24.
//

import Foundation

func decodeNetworkEvent(from jsonData: Data) -> NetworkEvent? {
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .iso8601
    
    // Attempt to decode the JSON data into PlayerJoinEvent
    if let playerJoinEvent = try? decoder.decode(NetworkPlayerJoinEvent.self, from: jsonData) {
        return playerJoinEvent
    }
    
//    // Attempt to decode the JSON data into PlayerMoveEvent
//    if let playerMoveEvent = try? decoder.decode(PlayerMoveEvent.self, from: jsonData) {
//        return playerMoveEvent
//    }
    
    // Add other event types as needed
    
    // If none of the above types match, throw an error
    return nil
}
