//
//  NetworkSelectLevelEvent.swift
//  star-dash
//
//  Created by Lau Rui han on 8/4/24.
//

import Foundation
class NetworkSelectLevelEvent: NetworkEvent {

    
    var level: LevelPersistable
    
    init(playerIndex: Int, level: LevelPersistable) {
        self.level = level
        super.init(event: .SelectLevel, playerIndex: playerIndex)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        level = try container.decode(LevelPersistable.self, forKey: .level)
        try super.init(from: decoder)
    }
    override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder) // Call super implementation first
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(level, forKey: .level)
    }

    private enum CodingKeys: String, CodingKey {
        case level
    }

}
