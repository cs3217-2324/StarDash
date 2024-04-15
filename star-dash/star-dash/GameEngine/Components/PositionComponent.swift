//
//  PositionComponent.swift
//  star-dash
//
//  Created by Lau Rui han on 12/3/24.
//

import Foundation

class PositionComponent: Component, Codable {
    var position: CGPoint
    var rotation: CGFloat
    var isFacingLeft: Bool

    init(id: UUID, entityId: UUID, position: CGPoint, rotation: CGFloat, isFacingLeft: Bool) {
        self.position = position
        self.rotation = rotation
        self.isFacingLeft = isFacingLeft
        super.init(id: id, entityId: entityId)
    }

    convenience init(entityId: UUID, position: CGPoint, rotation: CGFloat, isFacingLeft: Bool = false) {
        self.init(id: UUID(), entityId: entityId, position: position, rotation: rotation, isFacingLeft: isFacingLeft)
    }
    
    enum CodingKeys: String, CodingKey {
           case id, entityId, position, rotation, isFacingLeft
       }

    required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let idString = try container.decode(String.self, forKey: .id)
            let entityIdString = try container.decode(String.self, forKey: .entityId)
            position = try container.decode(CGPoint.self, forKey: .position)
            rotation = try container.decode(CGFloat.self, forKey: .rotation)
            isFacingLeft = try container.decode(Bool.self, forKey: .isFacingLeft)
            let id = UUID(uuidString: idString)!
            let entityId = UUID(uuidString: entityIdString)!
            super.init(id: id, entityId: entityId)
        }

        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(id.uuidString, forKey: .id)
            try container.encode(entityId.uuidString, forKey: .entityId)
            try container.encode(position, forKey: .position)
            try container.encode(rotation, forKey: .rotation)
            try container.encode(isFacingLeft, forKey: .isFacingLeft)
        }

}
