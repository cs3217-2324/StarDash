import Foundation

class PowerUpComponent: Component {
    let type: String

    init(id: ComponentId, entityId: EntityId, type: String) {
        self.type = type
        super.init(id: id, entityId: entityId)
    }

    convenience init(entityId: EntityId, type: String) {
        self.init(id: UUID(), entityId: entityId, type: type)
    }
}
