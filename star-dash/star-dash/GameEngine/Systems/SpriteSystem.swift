//
//  SpriteSystem.swift
//  star-dash
//
//  Created by Ho Jun Hao on 29/3/24.
//

import Foundation

class SpriteSystem: System {
    var isActive: Bool
    var dispatcher: EventModifiable?
    var entityManager: EntityManager
    var eventHandlers: [ObjectIdentifier: (Event) -> Void] = [:]

    init(_ entityManager: EntityManager, dispatcher: EventModifiable? = nil) {
        self.isActive = true
        self.entityManager = entityManager
        self.dispatcher = dispatcher
        setup()
    }

    func setup() {}

    func setSize(of entityId: EntityId, to newSize: CGSize) {
        guard let spriteComponent = getSpriteComponent(of: entityId) else {
            return
        }

        spriteComponent.size = newSize
    }

    private func getSpriteComponent(of entityId: EntityId) -> SpriteComponent? {
        entityManager.component(ofType: SpriteComponent.self, of: entityId)
    }
}
