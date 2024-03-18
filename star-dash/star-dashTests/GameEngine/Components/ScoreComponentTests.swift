//
//  ScoreComponentTests.swift
//  star-dashTests
//
//  Created by Jason Qiu on 18/3/24.
//

import Foundation
import XCTest
@testable import star_dash

final class ScoreComponentTests: XCTestCase {
    func testEqual_initComponent() {
        let player = createPlayerEntity()
        let scoreComponent = ScoreComponent(entityId: player.id, score: 0)
        XCTAssertEqual(scoreComponent.score, 0, "Score should be initialized")
    }
}
