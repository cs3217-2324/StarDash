import Foundation

class HomingMissileComponent: Component {
    var targetId: EntityId?
    let impulse: CGVector
    var isActivated = false

    init(id: ComponentId, entityId: EntityId, targetId: EntityId?, impulse: CGVector) {
        self.targetId = targetId
        self.impulse = impulse
        super.init(id: id, entityId: entityId)
    }

    convenience init(entityId: EntityId, targetId: EntityId?, impulse: CGVector) {
        self.init(id: UUID(), entityId: entityId, targetId: targetId, impulse: impulse)
    }
}
