import Foundation

class JumpComponent: Component {
    var duration: Double

    init(entityId: EntityId, duation: Double) {
        self.duration = duration
        super.init(id: UUID(), entityId: entityId)
    }
}
