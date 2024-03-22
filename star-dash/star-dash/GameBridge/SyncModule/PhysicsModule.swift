import CoreGraphics
import SDPhysicsEngine

class PhysicsModule: SyncModule {
    let entityManager: EntitySyncInterface

    init(entityManager: EntitySyncInterface) {
        self.entityManager = entityManager
    }

    func sync(entity: Entity, from object: SDObject) {
        guard let physicsComponent = entityManager.component(ofType: PhysicsComponent.self, of: entity.id),
              let body = object.physicsBody else {
            return
        }

        physicsComponent.mass = body.mass
        physicsComponent.velocity = body.velocity
        // physicsComponent.force = body.force
    }

    func sync(object: SDObject, from entity: Entity) {
        guard let physicsComponent = entityManager.component(ofType: PhysicsComponent.self, of: entity.id),
              let body = object.physicsBody else {
            return
        }

        body.mass = physicsComponent.mass
        body.velocity = physicsComponent.velocity
        // body.force = physicsComponent.force
    }

    func create(for object: SDObject, from entity: Entity) {
        guard let physicsComponent = entityManager.component(ofType: PhysicsComponent.self, of: entity.id) else {
            return
        }

        object.physicsBody = createRectanglePhysicsBody(physicsComponent: physicsComponent)
        object.physicsBody?.restitution = physicsComponent.restitution
        object.physicsBody?.isDynamic = physicsComponent.isDynamic
        object.physicsBody?.affectedByGravity = physicsComponent.affectedByGravity
        object.physicsBody?.categoryBitMask = physicsComponent.categoryBitMask
        object.physicsBody?.contactTestMask = physicsComponent.contactTestMask
        object.physicsBody?.collisionBitMask = physicsComponent.collisionBitMask
    }

    private func createRectanglePhysicsBody(physicsComponent: PhysicsComponent) -> SDPhysicsBody {
        SDPhysicsBody(rectangleOf: CGSize(width: 50, height: 50))
    }
}
