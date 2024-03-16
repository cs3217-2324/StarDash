import CoreGraphics
import SDPhysicsEngine

class ObjectModule: SyncModule {
    let entityManager: EntityManager

    init(entityManager: EntityManager) {
        self.entityManager = entityManager
    }

    func sync(entity: Entity, from object: SDObject) {
        guard let positionComponent = entityManager.component(ofType: PositionComponent.self, of: entity.id) else {
            return
        }

        positionComponent.setPosition(position: object.position)
        positionComponent.setRotation(rotation: Float(object.rotation))
    }

    func sync(object: SDObject, from entity: Entity) {
        guard let positionComponent = entityManager.component(ofType: PositionComponent.self, of: entity.id) else {
            return
        }

        object.position = positionComponent.position
        object.rotation = CGFloat(positionComponent.rotation)
    }

    func create(for object: SDObject, from entity: Entity) {
    }
}
