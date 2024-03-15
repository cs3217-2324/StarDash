import SDPhysicsEngine

protocol ObjectModule {
    let entityManager: EntityManager

    init(entityManager: EntityManager) {
        self.entityManager = entityManager
    }
    
    func sync(entity: Entity, into object: SDObject) {
        guard let physicsComponent = entityManager.component(ofType: PhysicsComponent.self, of: entity),
              let body = object.physicsBody else {
            return
        }

        body.mass = physicsComponent.mass
        body.velocity = physicsComponent.velocity
        body.force = physicsComponent.force
        body.affectedByGravity = physicsComponent.affectedByGravity
    }

    func create(for: object: SDObject, from entity: Entity) {
        guard let physicsComponent = entityManager.component(ofType: PhysicsComponent.self, of: entity) else {
            return
        }

        object.physicsBody = createRectanglePhysicsBody(physicsComponent)
    }

    private func createRectanglePhysicsBody(physicsComponent: PhysicsComponent) {
        guard let size = physicsComponent.size else {
            fatalError("Rectangle PhysicsComponent does not have a size")
        }

        return PhysicsBody(rectangleOf: CGSize(width: 50, height: 50))
    }
}
