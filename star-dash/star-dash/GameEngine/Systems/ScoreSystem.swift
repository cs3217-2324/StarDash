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
    
    func score(of entityId: EntityId) -> Int? {
        guard let scoreComponent = getScoreComponent(of: entityId) else {
            return nil
        }
        
        return scoreComponent.score
    }

    func applyScoreChange(to entityId: EntityId, scoreChange: Int) {
        guard let scoreComponent = getScoreComponent(of: entityId) else {
            return
        }

        scoreComponent.score += scoreChange
    }

    private func getScoreComponent(of entityId: EntityId) -> ScoreComponent? {
        entityManager.component(ofType: ScoreComponent.self, of: entityId)
    }
}
