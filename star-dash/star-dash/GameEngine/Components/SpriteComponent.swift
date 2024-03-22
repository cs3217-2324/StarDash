//
//  SpriteComponent.swift
//  star-dash
//
//  Created by Lau Rui han on 12/3/24.
//

import Foundation

class SpriteComponent: Component {
    var image: String
    var textureAtlas: String?
    var size: CGSize?

    init(id: ComponentId, entityId: EntityId, image: String, textureAtlas: String?, size: CGSize?) {
        self.image = image
        self.size = size
        self.textureAtlas = textureAtlas
        super.init(id: id, entityId: entityId)
    }

    convenience init(entityId: EntityId, image: String, textureAtlas: String?, size: CGSize?) {
        self.init(id: UUID(), entityId: entityId, image: image, textureAtlas: textureAtlas, size: size)
    }
}
