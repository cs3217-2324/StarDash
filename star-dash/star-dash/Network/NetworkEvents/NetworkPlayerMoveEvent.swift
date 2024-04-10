//
//  NetworkPlayerMoveEvent.swift
//  star-dash
//
//  Created by Lau Rui han on 8/4/24.
//

import Foundation
class NetworkPlayerMoveEvent: NetworkEvent {
    
    var isLeft: Bool
    
    init( playerIndex: Int, isLeft: Bool) {

        self.isLeft = isLeft
        super.init(event: .PlayerMove, playerIndex: playerIndex)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        isLeft = try container.decode(Bool.self, forKey: .isLeft)
        try super.init(from: decoder)
    }
    override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder) // Call super implementation first
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(isLeft, forKey: .isLeft)
    }
    private enum CodingKeys: String, CodingKey {
        case isLeft
    }
    
}


