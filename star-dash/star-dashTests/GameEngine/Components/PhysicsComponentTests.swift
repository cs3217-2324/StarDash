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
    func testEqual_initComponent() {
        let player = createPlayerEntity()
        let physicsComponent = PhysicsComponent(entityId: player.id, size: .zero)
        XCTAssertEqual(physicsComponent.size, .zero, "Size should be initialized")
    }
}
