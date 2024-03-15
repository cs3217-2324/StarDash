import SDPhysicsEngine

protocol ObjectModule {
    let entitiesManager: EntitiesManager

    init(entitiesManager: EntitiesManager) {
        self.entitiesManager = entitiesManager
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
