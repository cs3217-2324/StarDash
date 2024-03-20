import CoreGraphics
import SDPhysicsEngine

class ObjectModule: SyncModule {
    let entityManager: EntitySyncInterface

    init(entityManager: EntitySyncInterface) {
        self.entityManager = entityManager
    }

    func sync(entity: Entity, from object: SDObject) {
        guard let positionComponent = entityManager.component(ofType: PositionComponent.self, of: entity.id) else {
            return
        }

        positionComponent.position = object.position
        positionComponent.rotation = object.rotation
    }

    func sync(object: SDObject, from entity: Entity) {
        guard let positionComponent = entityManager.component(ofType: PositionComponent.self, of: entity.id) else {
            return
        }

        object.position = positionComponent.position
        object.rotation = positionComponent.rotation
    }

    func create(for object: SDObject, from entity: Entity) {
    }
}
