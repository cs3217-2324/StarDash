import Foundation

class SpeedBoostComponent: Component {
    let multiplier: Float
    var duration: Float
    var isActivated = false

    init(id: ComponentId, entityId: EntityId, duration: Float, multiplier: Float) {
        self.duration = duration
        self.multiplier = multiplier
        super.init(id: id, entityId: entityId)
    }

    convenience init(entityId: EntityId, duration: Float, multiplier: Float) {
        self.init(id: UUID(), entityId: entityId, duration: duration, multiplier: multiplier)
    }
}
