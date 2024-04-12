//
//  NetworkEvent.swift
//  star-dash
//
//  Created by Lau Rui han on 8/4/24.
//

import Foundation
class NetworkEvent: Codable {
    let event: NetworkEventType
    let playerIndex: Int
    let timestamp: Date
    init(event: NetworkEventType, playerIndex: Int, timestamp: Date) {
        self.event = event
        self.playerIndex = playerIndex
        self.timestamp = timestamp
    }
    enum CodingKeys: String, CodingKey {
           case event
           case playerIndex
           case timestamp
       }

       required init(from decoder: Decoder) throws {
           let container = try decoder.container(keyedBy: CodingKeys.self)
           event = try container.decode(NetworkEventType.self, forKey: .event)
           playerIndex = try container.decode(Int.self, forKey: .playerIndex)

           // Decode the date from a double representing the Unix timestamp
           let date = try container.decode(Double.self, forKey: .timestamp)
           timestamp = Date(timeIntervalSince1970: date)
       }

       func encode(to encoder: Encoder) throws {
           var container = encoder.container(keyedBy: CodingKeys.self)
           try container.encode(event, forKey: .event)
           try container.encode(playerIndex, forKey: .playerIndex)

           // Encode the date as a double representing the Unix timestamp
           try container.encode(timestamp.timeIntervalSince1970, forKey: .timestamp)
       }
}
