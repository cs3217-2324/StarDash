import CoreGraphics
import SDPhysicsEngine

class ObjectModule: SyncModule {
    let entityManager: EntityManager

    init(entityManager: EntityManager) {
        self.entityManager = entityManager
    }

    func sync(entity: Entity, into object: SDObject) {
        guard let positionComponent = entityManager.component(ofType: PositionComponent.self, of: entity.id) else {
            return
        }

        object.position = positionComponent.position
        object.rotation = CGFloat(positionComponent.rotation)
    }

    func create(for object: SDObject, from entity: Entity) {
    }
}
