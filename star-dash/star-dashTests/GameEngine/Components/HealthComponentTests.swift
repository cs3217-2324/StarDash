//
//  HealthComponent.swift
//  star-dashTests
//
//  Created by Lau Rui han on 18/3/24.
//

import Foundation
import XCTest
@testable import star_dash

final class HealthComponentTest: XCTestCase {
    func testEqual_initComponent() {
        let player = createPlayerEntity()
        let healthComponent = HealthComponent(entityId: player.id, health: 100)
        XCTAssertEqual(healthComponent.health, 100, "Health should be initialized")
    }
}
