import Foundation

class BuffComponent: Component {
    var speedMultiplier: Int = 1

    init(id: ComponentId, entityId: EntityId) {
        super.init(id: id, entityId: entityId)
    }

    convenience init(entityId: EntityId) {
        self.init(id: UUID(), entityId: entityId)
    }
}
