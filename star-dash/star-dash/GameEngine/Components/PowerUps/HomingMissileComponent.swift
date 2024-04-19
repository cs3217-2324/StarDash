import Foundation

class HomingMissileComponent: Component {
    var targetId: EntityId?
    let sourceId: EntityId?
    let impulse: CGVector
    var isActivated = false

    init(id: ComponentId, entityId: EntityId, targetId: EntityId?, sourceId: EntityId?, impulse: CGVector) {
        self.targetId = targetId
        self.sourceId = sourceId
        self.impulse = impulse
        super.init(id: id, entityId: entityId)
    }

    convenience init(entityId: EntityId, targetId: EntityId?, sourceId: EntityId?, impulse: CGVector) {
        self.init(id: UUID(), entityId: entityId, targetId: targetId, sourceId: sourceId, impulse: impulse)
    }
}
