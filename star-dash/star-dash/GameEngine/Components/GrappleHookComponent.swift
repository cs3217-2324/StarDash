//
//  GrappleHookComponent.swift
//  star-dash
//
//  Created by Ho Jun Hao on 18/3/24.
//

import Foundation

class GrappleHookComponent: Component {
    static let hookShootVector = CGVector(dx: 10, dy: -10)
    static let angleMoved: Double = 3
    static let MIN_LENGTH: Double = 80
    static let releaseImpulseMagnitude: Double = 600

    let maxLength: Double
    var lengthToRetract: Double = 70
    var angleToSwing: Double = 90
    var state: HookState

    init(id: ComponentId, entityId: EntityId, maxLength: Double) {
        self.maxLength = maxLength
        self.state = .idle
        super.init(id: id, entityId: entityId)
    }

    convenience init(entityId: EntityId, maxLength: Double) {
        self.init(id: UUID(), entityId: entityId, maxLength: maxLength)
    }
}

enum HookState {
    case idle
    case shooting
    case retracting
    case swinging
    case releasing
}
