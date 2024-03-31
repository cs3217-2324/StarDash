//
//  PhysicsCompoenntTests.swift
//  star-dashTests
//
//  Created by Lau Rui han on 18/3/24.
//

import Foundation
import XCTest
@testable import star_dash

final class PhysicsComponentTests: XCTestCase {
    func testEqual_initRectangleComponent() {
        let player = createPlayerEntity()
        let physicsComponent = PhysicsComponent(entityId: player.id, rectangleOf: .zero)
        XCTAssertEqual(physicsComponent.size, .zero, "Size should be initialized")
    }

    func testEqual_initCircleComponent() {
        let player = createPlayerEntity()
        let physicsComponent = PhysicsComponent(entityId: player.id, circleOf: .zero)
        XCTAssertEqual(physicsComponent.radius, .zero, "Size should be initialized")
    }
}
