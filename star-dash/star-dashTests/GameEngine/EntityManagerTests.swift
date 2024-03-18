//
//  EntityManagerTests.swift
//  star-dashTests
//
//  Created by Lau Rui han on 17/3/24.
//

import XCTest
@testable import star_dash

final class EntityManagerTests: XCTestCase {

    func testEqual_addEntity() {
        let entityManager = createEntityManager()
        let player = createPlayerEntity()
        entityManager.add(entity: player)
        XCTAssertEqual(entityManager.entityMap.count, 1, "Entity should be added to the entityMap")
    }

    func testEqual_addSameEntity() {
        let entityManager = createEntityManager()
        let player = createPlayerEntity()
        entityManager.add(entity: player)
        entityManager.add(entity: player)
        XCTAssertEqual(entityManager.entityMap.count, 1, "Repeated entity should not be added to the entityMap")
    }

    func testEqual_removeEntity() {
        let entityManager = createEntityManager()
        let player = createPlayerEntity()
        entityManager.add(entity: player)
        entityManager.remove(entity: player)
        XCTAssertEqual(entityManager.entityMap.count, 0, "Entity should be removed from the entityMap")
    }

    func testEqual_removeEntityNotInList() {
        let entityManager = createEntityManager()
        let player = createPlayerEntity()
        entityManager.remove(entity: player)
        XCTAssertEqual(entityManager.entityMap.count, 0, "Entity should not be removed from the entityMap")
    }

    func testNotNil_getEntity() {
        let entityManager = createEntityManager()
        let player = createPlayerEntity()
        entityManager.add(entity: player)
        let entity = entityManager.entity(with: player.id)
        XCTAssertNotNil(entity, "Entity should be retrieved from the entityMap")
    }

    func testNotNil_getComponent() {
        let entityManager = createEntityManager()
        let player = createPlayerEntity()
        entityManager.add(entity: player)
        player.setUpAndAdd(to: entityManager)
        let positionComponent = entityManager.component(ofType: PositionComponent.self, of: player.id)
        XCTAssertNotNil(positionComponent, "Component should be retrieved from the componentMap")
    }

    func testNil_getComponentOfRemovedEntity() {
        let entityManager = createEntityManager()
        let player = createPlayerEntity()
        entityManager.add(entity: player)
        player.setUpAndAdd(to: entityManager)
        entityManager.remove(entity: player)
        let positionComponent = entityManager.component(ofType: PositionComponent.self, of: player.id)
        XCTAssertNil(positionComponent, "Component should not be retrieved from the componentMap if entity is removed")
    }

    func testNil_getEntityOfRemovedEntity() {
        let entityManager = createEntityManager()
        let player = createPlayerEntity()
        entityManager.add(entity: player)
        player.setUpAndAdd(to: entityManager)
        entityManager.remove(entity: player)
        let entity = entityManager.entity(with: player.id)
        XCTAssertNil(entity, "Entity should not be retrieved from the entityMap if entity is removed")
    }

}
