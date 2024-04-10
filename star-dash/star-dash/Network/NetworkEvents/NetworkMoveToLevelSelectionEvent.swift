//
//  NetworkMoveToLevelSelectionEvent.swift
//  star-dash
//
//  Created by Lau Rui han on 8/4/24.
//

import Foundation

class NetworkMoveToLevelSelectionEvent: NetworkEvent{

    init(playerIndex: Int) {
        super.init(event: .MoveToLevelSelection, playerIndex: playerIndex)
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }
}
