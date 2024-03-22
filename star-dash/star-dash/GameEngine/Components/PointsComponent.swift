import Foundation

class PointsComponent: Component {
    let points: Int

    init(id: UUID, entityId: UUID, points: Int) {
        self.points = points
        super.init(id: id, entityId: entityId)
    }

    convenience init(entityId: UUID, points: Int) {
        self.init(id: UUID(), entityId: entityId, points: points)
    }
}
