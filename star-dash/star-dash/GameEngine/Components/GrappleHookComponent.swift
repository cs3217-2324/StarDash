//
//  GrappleHookComponent.swift
//  star-dash
//
//  Created by Ho Jun Hao on 18/3/24.
//

import Foundation

class GrappleHookComponent: Component {
    let maxLength: Double
    var lengthToRetract: Double = GameConstants.Hook.defaultRetractLength
    var angleToSwing: Double = GameConstants.Hook.defaultSwingAngle
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
