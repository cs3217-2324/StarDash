//
//  GrappleHookComponent.swift
//  star-dash
//
//  Created by Ho Jun Hao on 28/3/24.
//

import Foundation

class GrappleHookComponent: Component {
    var startpoint: CGPoint
    let shootPoint: CGPoint
    let isLeft: Bool
    var lengthToRetract: Double = GameConstants.Hook.defaultRetractLength
    var angleToSwing: Double = GameConstants.Hook.defaultSwingAngle
    var state: HookState = .shooting

    init(id: ComponentId, entityId: EntityId, startpoint: CGPoint, isLeft: Bool) {
        self.startpoint = startpoint
        self.shootPoint = startpoint
        self.isLeft = isLeft
        super.init(id: id, entityId: entityId)
    }

    convenience init(entityId: EntityId, startpoint: CGPoint, isLeft: Bool) {
        self.init(id: UUID(), entityId: entityId, startpoint: startpoint, isLeft: isLeft)
    }
}

enum HookState {
    case shooting
    case retracting
    case swinging
    case releasing
}
