//
//  SpriteComponent.swift
//  star-dash
//
//  Created by Lau Rui han on 12/3/24.
//

import Foundation

class SpriteComponent: Component {
    // TODO: sprite could be single image or sprite set, could use enum to seperate,
    // for sprite set will need to discuss how to rep animation
    var image: String
    var size: CGSize

    init(id: ComponentId = UUID(), entityId: EntityId, image: String, size: CGSize) {
        self.image = image
        self.size = size
        super.init(id: id, entityId: entityId)
    }
}
