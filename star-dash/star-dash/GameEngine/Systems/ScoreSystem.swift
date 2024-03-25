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
    var eventHandlers: [ObjectIdentifier: (Event) -> Void] = [:]

    init(_ entityManager: EntityManager, dispatcher: EventModifiable? = nil) {
        self.isActive = true
        self.entityManager = entityManager
        self.dispatcher = dispatcher
        setUpEventHandlers()
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

    func setUpEventHandlers() {
        dispatcher?.registerListener(for: PickupCollectibleEvent.self, listener: self)

        eventHandlers[ObjectIdentifier(PickupCollectibleEvent.self)] = { event in
            if let pickupCollectibleEvent = event as? PickupCollectibleEvent {
                self.handlePickupCollectibleEvent(event: pickupCollectibleEvent)
            }
        }
    }

    private func handlePickupCollectibleEvent(event: PickupCollectibleEvent) {
        guard let pointsComponent = entityManager.component(ofType: PointsComponent.self,
                                                            of: event.collectibleEntityId) else {
            return
        }

        applyScoreChange(to: event.entityId, scoreChange: pointsComponent.points)
        dispatcher?.add(event: RemoveEvent(on: event.collectibleEntityId))
    }

    private func getScoreComponent(of entityId: EntityId) -> ScoreComponent? {
        entityManager.component(ofType: ScoreComponent.self, of: entityId)
    }
}
