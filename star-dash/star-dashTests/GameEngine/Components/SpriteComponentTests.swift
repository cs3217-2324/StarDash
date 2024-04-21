//
//  SpriteComponentTests.swift
//  star-dashTests
//
//  Created by Lau Rui han on 18/3/24.
//

import Foundation
import XCTest
@testable import star_dash

final class SpriteComponentTests: XCTestCase {
    func testEqual_initComponent() {
        let player = createPlayerEntity()
        let textureSet = createTextureSet()
        let imageSet = createImageSet()
        let spriteComponent = SpriteComponent(
            entityId: player.id,
            image: imageSet,
            imageMode: "",
            textureSet: textureSet,
            textureAtlas: "",
            size: .zero)
        XCTAssertEqual(spriteComponent.image?.faceLeft, imageSet.faceLeft, "Image should be initialized")
        XCTAssertEqual(spriteComponent.imageMode, "", "ImageMode should be initialized")
        XCTAssertEqual(spriteComponent.textureSet?.run, textureSet.run, "TextureSet should be initialized")
        XCTAssertEqual(spriteComponent.textureAtlas, "", "TextureAtlas should be initialized")
        XCTAssertEqual(spriteComponent.size, .zero, "Size should be initialized")
    }
}
