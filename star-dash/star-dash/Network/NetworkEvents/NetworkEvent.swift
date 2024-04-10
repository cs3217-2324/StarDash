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
    init(event: NetworkEventType, playerIndex: Int) {
        self.event = event
        self.playerIndex = playerIndex
    }
}
