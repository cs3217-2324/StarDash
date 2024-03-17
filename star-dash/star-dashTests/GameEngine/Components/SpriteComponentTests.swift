//
//  SpriteComponent.swift
//  star-dashTests
//
//  Created by Lau Rui han on 18/3/24.
//

import Foundation
import XCTest
@testable import star_dash

final class SpriteComponentTest: XCTestCase {
    func testEqual_initComponent() {
        let player = createPlayerEntity()
        let spriteComponent = SpriteComponent(entityId: player.id, image: "", textureAtlas: "", size: .zero)
        XCTAssertEqual(spriteComponent.size, .zero, "Size should be initialized")
        XCTAssertEqual(spriteComponent.image, "", "Image should be initialized")
        XCTAssertEqual(spriteComponent.textureAtlas, "", "TextureAtlas should be initialized")
    }
}
