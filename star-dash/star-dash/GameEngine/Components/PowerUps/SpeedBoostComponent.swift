import Foundation

class SpeedBoostComponent: Component {
    let multiplier: CGFloat
    var duration: Float
    var isActivated = false

    init(id: ComponentId, entityId: EntityId, duration: Float, multiplier: CGFloat) {
        self.duration = duration
        self.multiplier = multiplier
        super.init(id: id, entityId: entityId)
    }

    convenience init(entityId: EntityId, duration: Float, multiplier: CGFloat) {
        self.init(id: UUID(), entityId: entityId, duration: duration, multiplier: multiplier)
    }
}
