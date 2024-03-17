//
//  PositionComponent.swift
//  star-dashTests
//
//  Created by Lau Rui han on 18/3/24.
//

import Foundation
import XCTest
@testable import star_dash

final class PositionComponentTest: XCTestCase {
    func testEqual_initComponent() {
        let player = createPlayerEntity()
        let positionComponent = PositionComponent(entityId: player.id, position: .zero, rotation: .zero)
        XCTAssertEqual(positionComponent.position, .zero, "Position should be initialized")
        XCTAssertEqual(positionComponent.rotation, .zero, "Rotation should be initialized")
    }
}
