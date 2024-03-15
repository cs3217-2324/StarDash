//
//  PositionSystem.swift
//  star-dash
//
//  Created by Ho Jun Hao on 13/3/24.
//

import Foundation

class PositionSystem: System {
    var isActive: Bool
    var dispatcher: EventModifiable?
    var entityManager: EntityManager

    init(_ entityManager: EntityManager, dispatcher: EventModifiable? = nil) {
        self.isActive = true
        self.entityManager = entityManager
        self.dispatcher = dispatcher
    }

    func move(entityId: EntityId, to newPosition: CGPoint) {
        guard let positionComponent = getPositionComponent(of: entityId) else {
            return
        }

        positionComponent.setPosition(position: newPosition)
    }

    func rotate(entityId: EntityId, to newRotation: Float) {
        guard let positionComponent = getPositionComponent(of: entityId) else {
            return
        }

        positionComponent.setRotation(rotation: newRotation)
    }

    func sync(entityPositionMap: [EntityId: CGPoint], entityRotationMap: [EntityId: Float]) {
        for (entityId, newPosition) in entityPositionMap {
            move(entityId: entityId, to: newPosition)
        }

        for (entityId, newRotation) in entityRotationMap {
            rotate(entityId: entityId, to: newRotation)
        }
    }

    private func getPositionComponent(of entityId: EntityId) -> PositionComponent? {
        entityManager.component(ofType: PositionComponent.self, of: entityId)
    }
}
