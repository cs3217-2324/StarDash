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

    func rotate(entityId: EntityId, to newRotation: CGFloat) {
        guard let positionComponent = getPositionComponent(of: entityId) else {
            return
        }

        positionComponent.setRotation(rotation: newRotation)
    }

    func getPosition(of entityId: EntityId) -> CGPoint? {
        guard let positionComponent = getPositionComponent(of: entityId) else {
            return nil
        }

        return positionComponent.position
    }

    private func getPositionComponent(of entityId: EntityId) -> PositionComponent? {
        entityManager.component(ofType: PositionComponent.self, of: entityId)
    }
}
