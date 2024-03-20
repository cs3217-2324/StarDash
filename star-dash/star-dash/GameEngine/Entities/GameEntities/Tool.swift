//
//  Tool.swift
//  star-dash
//
//  Created by Lau Rui han on 12/3/24.
//

import Foundation

class Tool: Entity {
    static let DEFAULT_MAX_LENGTH: Double = 600

    let id: EntityId
    private let startPoint: CGPoint
    private let endPoint: CGPoint
    private let playerId: EntityId

    init(id: EntityId, startPoint: CGPoint, endPoint: CGPoint, playerId: EntityId) {
        self.id = id
        self.startPoint = startPoint
        self.endPoint = endPoint
        self.playerId = playerId
    }

    convenience init(startPoint: CGPoint, endPoint: CGPoint, playerId: EntityId) {
        self.init(id: UUID(), startPoint: startPoint, endPoint: endPoint, playerId: playerId)
    }

    func setUpAndAdd(to: EntityManager) {
        let toolComponent = ToolComponent(entityId: self.id, maxLength: Tool.DEFAULT_MAX_LENGTH)
        let toolOwnerComponent = ToolOwnerComponent(entityId: self.id, playerId: playerId)
        let physicsComponent = PhysicsComponent(entityId: self.id, startPoint: startPoint, endPoint: endPoint)
        physicsComponent.collisionBitMask = PhysicsConstants.CollisionMask.tool

        to.add(entity: self)
        to.add(component: physicsComponent)
        to.add(component: toolComponent)
        to.add(component: toolOwnerComponent)
    }
}
