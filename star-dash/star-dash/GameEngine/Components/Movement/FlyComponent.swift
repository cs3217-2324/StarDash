import Foundation

class FlyComponent: Component {
    var duration: Double

    init(entityId: EntityId, duration: Double) {
        self.duration = duration
        super.init(id: UUID(), entityId: entityId)
    }
}
