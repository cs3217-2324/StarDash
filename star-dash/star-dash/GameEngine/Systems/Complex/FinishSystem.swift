//
//  FinishSystem.swift
//  star-dash
//
//  Created by Jason Qiu on 14/4/24.
//

import Foundation

class FinishSystem: System {
    var isActive: Bool
    var dispatcher: EventModifiable?
    var entityManager: EntityManager
    var eventHandlers: [ObjectIdentifier: (Event) -> Void] = [:]

    init(_ entityManager: EntityManager, dispatcher: EventModifiable? = nil) {
        self.isActive = true
        self.entityManager = entityManager
        self.dispatcher = dispatcher
    }

    func update(by deltaTime: TimeInterval) {
        guard let positionSystem = dispatcher?.system(ofType: PositionSystem.self),
              let playerSystem = dispatcher?.system(ofType: PlayerSystem.self),
              let finishLine = entityManager.finishLineEntity(),
              let finishLinePosition = positionSystem.getPosition(of: finishLine.id) else {
            return
        }

        for player in entityManager.playerEntities() {
            guard let hasPlayerFinishedGame =
                    playerSystem.hasPlayerFinishedGame(entityId: player.id), !hasPlayerFinishedGame else {
                continue
            }

            guard let playerPosition = positionSystem.getPosition(of: player.id) else {
                continue
            }
            if playerPosition.x >= finishLinePosition.x {
                playerSystem.setHasFinishedGame(of: player.id, to: true)
            }
        }
    }
}
