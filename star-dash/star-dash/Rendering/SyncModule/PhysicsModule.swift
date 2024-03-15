import CoreGraphics
import SDPhysicsEngine

class PhysicsModule: SyncModule {
    let entityManager: EntityManager

    init(entityManager: EntityManager) {
        self.entityManager = entityManager
    }
    
    func sync(entity: Entity, into object: SDObject) {
        guard let physicsComponent = entityManager.component(ofType: PhysicsComponent.self, of: entity.id),
              let body = object.physicsBody else {
            return
        }

        body.mass = physicsComponent.mass
        body.velocity = physicsComponent.velocity
        body.force = physicsComponent.force
        body.affectedByGravity = physicsComponent.affectedByGravity
    }

    func create(for object: SDObject, from entity: Entity) {
        guard let physicsComponent = entityManager.component(ofType: PhysicsComponent.self, of: entity.id) else {
            return
        }

        object.physicsBody = createRectanglePhysicsBody(physicsComponent: physicsComponent)
    }

    private func createRectanglePhysicsBody(physicsComponent: PhysicsComponent) -> SDPhysicsBody {
        return SDPhysicsBody(rectangleOf: CGSize(width: 50, height: 50))
    }
}
