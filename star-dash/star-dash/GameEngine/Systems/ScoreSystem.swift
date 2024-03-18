//
//  ScoreSystem.swift
//  star-dash
//
//  Created by Jason Qiu on 17/3/24.
//

import Foundation

class ScoreSystem: System {
    var isActive: Bool
    var dispatcher: EventModifiable?
    var entityManager: EntityManager

    init(_ entityManager: EntityManager, dispatcher: EventModifiable? = nil) {
        self.isActive = true
        self.entityManager = entityManager
        self.dispatcher = dispatcher
    }

    func increaseScore(of entityId: EntityId, by increment: Int) {
        guard let scoreComponent = getScoreComponent(of: entityId) else {
            return
        }

        scoreComponent.score += increment
    }

    func decreaseScore(of entityId: EntityId, by decrement: Int) {
        guard let scoreComponent = getScoreComponent(of: entityId) else {
            return
        }

        scoreComponent.score -= decrement
    }

    private func getScoreComponent(of entityId: EntityId) -> ScoreComponent? {
        entityManager.component(ofType: ScoreComponent.self, of: entityId)
    }
}
