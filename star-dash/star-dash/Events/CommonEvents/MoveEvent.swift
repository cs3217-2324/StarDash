//
//  MoveEvent.swift
//  star-dash
//
//  Created by Jason Qiu on 14/3/24.
//

import Foundation

class MoveEvent: Event {
    let timestamp: Date
    let entityId: EntityId

    let toLeft: Bool

    init(on entityId: EntityId, toLeft: Bool) {
        timestamp = Date.now
        self.entityId = entityId
        self.toLeft = toLeft
    }

    func execute(on target: EventModifiable) {
        guard let physicsComponent = target.component(ofType: PhysicsComponent.self, ofEntity: entityId),
              let spriteComponent = target.component(ofType: SpriteComponent.self, ofEntity: entityId),
              let textureSet = spriteComponent.textureSet else {
            return
        }

        physicsComponent.velocity = (toLeft ? -1 : 1) * PhysicsConstants.runVelocity
        spriteComponent.textureAtlas = textureSet.run
    }
}
