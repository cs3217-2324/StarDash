import Foundation

class HomingMissleComponent: Component {
    var targetId: EntityId?
    let impulse: CGVector

    init(id: ComponentId, entityId: EntityId, targetId: EntityId?, impulse: CGVector) {
        self.targetId = targetId
        self.impulse = speed
        super.init(id: id, entityId: entityId)
    }

    convenience init(entityId: EntityId, targetId: EntityId?, impulse: CGVector) {
        self.init(id: UUID(), entityId: entityId, targetId: targetId, impulse: CGVector)
    }
}
