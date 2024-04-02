//
//  GrappleHookComponent.swift
//  star-dash
//
//  Created by Ho Jun Hao on 28/3/24.
//

import Foundation

class GrappleHookComponent: Component {
    var startpoint: CGPoint
    var lengthToRetract: Double = GameConstants.Hook.defaultRetractLength
    var angleToSwing: Double = GameConstants.Hook.defaultSwingAngle
    var state: HookState = .shooting

    init(id: ComponentId, entityId: EntityId, startpoint: CGPoint) {
        self.startpoint = startpoint
        super.init(id: id, entityId: entityId)
    }

    convenience init(entityId: EntityId, startpoint: CGPoint) {
        self.init(id: UUID(), entityId: entityId, startpoint: startpoint)
    }
}

enum HookState {
    case shooting
    case retracting
    case swinging
    case releasing
}
