//
//  SpriteComponent.swift
//  star-dash
//
//  Created by Lau Rui han on 12/3/24.
//

import Foundation

class SpriteComponent: Component {
    var image: String
    var textureSet: TextureSet?
    var textureAtlas: String?
    var size: CGSize?

    init(
        id: ComponentId,
        entityId: EntityId,
        image: String,
        textureSet: TextureSet?,
        textureAtlas: String?,
        size: CGSize?
    ) {
        self.image = image
        self.size = size
        self.textureSet = textureSet
        self.textureAtlas = textureAtlas
        super.init(id: id, entityId: entityId)
    }

    convenience init(
        entityId: EntityId,
        image: String,
        textureSet: TextureSet?,
        textureAtlas: String?,
        size: CGSize?
    ) {
        self.init(
            id: UUID(),
            entityId: entityId,
            image: image,
            textureSet: textureSet,
            textureAtlas: textureAtlas,
            size: size
        )
    }

    convenience init(
        entityId: EntityId,
        image: String,
        textureSet: TextureSet?,
        textureAtlas: String?,
        radius: CGFloat?
    ) {
        guard let radius = radius else {
            self.init(
                entityId: entityId,
                image: image,
                textureSet: textureSet,
                textureAtlas: textureAtlas,
                size: nil
            )
            return
        }
        let size = CGSize(width: radius * 2, height: radius * 2)
        self.init(
            entityId: entityId,
            image: image,
            textureSet: textureSet,
            textureAtlas: textureAtlas,
            size: size
        )
    }
}
