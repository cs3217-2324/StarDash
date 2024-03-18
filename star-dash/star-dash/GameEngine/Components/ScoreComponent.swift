//
//  ScoreComponent.swift
//  star-dash
//
//  Created by Jason Qiu on 18/3/24.
//

import Foundation

class ScoreComponent: Component {
    var score: Int

    init(id: ComponentId, entityId: EntityId, score: Int) {
        self.score = score
        super.init(id: id, entityId: entityId)
    }

    convenience init(entityId: EntityId, score: Int) {
        self.init(id: UUID(), entityId: entityId, score: score)
    }
}
