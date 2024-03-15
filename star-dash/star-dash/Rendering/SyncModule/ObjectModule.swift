import SDPhysicsEngine

protocol ObjectModule {
    let entityManager: EntityManager

    init(entityManager: EntityManager) {
        self.entityManager = entityManager
    }
    
    func sync(entity: Entity, into object: SDObject) {
        guard let positionComponent = entityManager.component(ofType: PositionComponent.self, of: entity) else {
            return
        }

        object.position = positionComponent.position
        object.rotation = positionComponent.rotation
    }

    func create(for: object: SDObject, from entity: Entity) {
        guard let positionComponent = entityManager.component(ofType: PositionComponent.self, of: entity) else {
            return
        }

        let object = SDObject()
        object.position = positionComponent.position
        object.rotation = positionComponent.rotation

        return object
    }
}
